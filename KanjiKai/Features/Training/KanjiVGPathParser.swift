//
//  KanjiVGPathParser.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 29/05/2026.
//

import Foundation
import SwiftUI

enum KanjiVGStrokeProvider {
    static func strokes(for kanji: KanjiItem) -> [KanjiStroke] {
        guard let fileName = kanji.kanjiVGFileName,
              let pathData = KanjiVGLoader.pathData(fileName: fileName) else {
            return kanji.trainingStrokes
        }

        guard !kanji.trainingStrokes.isEmpty else {
            return pathData.enumerated().map { index, pathData in
                syntheticStroke(id: index + 1, pathData: pathData)
            }
        }

        guard pathData.count == kanji.trainingStrokes.count else {
            return kanji.trainingStrokes
        }

        return zip(kanji.trainingStrokes, pathData).map { stroke, pathData in
            let guidePoints = KanjiVGPathParser.normalizedGuidePoints(from: pathData)
            let endpoints = guidePoints.flatMap { points -> (start: CGPoint, end: CGPoint)? in
                guard let start = points.first, let end = points.last else { return nil }
                return (start, end)
            }
            return stroke.withSVGPathData(pathData, endpoints: endpoints, guidePoints: guidePoints)
        }
    }

    private static func syntheticStroke(id: Int, pathData: String) -> KanjiStroke {
        let guidePoints = KanjiVGPathParser.normalizedGuidePoints(from: pathData) ?? []
        let startPoint = guidePoints.first ?? .zero
        let endPoint = guidePoints.last ?? startPoint

        return KanjiStroke(
            id: id,
            strokeType: strokeType(from: startPoint, to: endPoint),
            startPoint: startPoint,
            endPoint: endPoint,
            cornerPoint: nil,
            direction: direction(from: startPoint, to: endPoint),
            guidePoints: guidePoints,
            svgPathData: pathData
        )
    }

    private static func strokeType(from startPoint: CGPoint, to endPoint: CGPoint) -> KanjiStrokeType {
        abs(endPoint.y - startPoint.y) > abs(endPoint.x - startPoint.x) ? .vertical : .horizontal
    }

    private static func direction(from startPoint: CGPoint, to endPoint: CGPoint) -> KanjiStrokeDirection {
        if abs(endPoint.y - startPoint.y) > abs(endPoint.x - startPoint.x) {
            return .topToBottom
        }

        return .leftToRight
    }
}

private enum KanjiVGLoader {
    static func pathData(fileName: String) -> [String]? {
        guard let url = resourceURL(fileName: fileName),
              let svg = try? String(contentsOf: url, encoding: .utf8) else {
            return nil
        }

        let pattern = #"<path\b[^>]*\bd=\"([^\"]+)\""#
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return nil
        }

        let range = NSRange(svg.startIndex..<svg.endIndex, in: svg)
        return regex.matches(in: svg, range: range).compactMap { match in
            guard let pathRange = Range(match.range(at: 1), in: svg) else { return nil }
            return String(svg[pathRange])
        }
    }

    private static func resourceURL(fileName: String) -> URL? {
        Bundle.main.url(forResource: fileName, withExtension: "svg", subdirectory: "KanjiVG")
            ?? Bundle.main.url(forResource: fileName, withExtension: "svg", subdirectory: "Data/KanjiVG")
            ?? Bundle.main.url(forResource: fileName, withExtension: "svg")
    }
}

enum KanjiVGPathParser {
    static func path(from pathData: String, in size: CGSize, viewBoxSize: CGFloat = 109) -> Path {
        var parser = SVGPathParser(pathData: pathData, size: size, viewBoxSize: viewBoxSize)
        return parser.parse()
    }

    static func normalizedEndpoints(from pathData: String, viewBoxSize: CGFloat = 109) -> (start: CGPoint, end: CGPoint)? {
        guard let guidePoints = normalizedGuidePoints(from: pathData, viewBoxSize: viewBoxSize),
              let start = guidePoints.first,
              let end = guidePoints.last else {
            return nil
        }

        return (start, end)
    }

    static func normalizedGuidePoints(from pathData: String, viewBoxSize: CGFloat = 109) -> [CGPoint]? {
        var parser = SVGPathParser(pathData: pathData, size: CGSize(width: viewBoxSize, height: viewBoxSize), viewBoxSize: viewBoxSize)
        _ = parser.parse()
        let points = parser.sampledCanvasPoints.map {
            CGPoint(x: $0.x / viewBoxSize, y: $0.y / viewBoxSize)
        }

        guard !points.isEmpty else {
            return nil
        }

        return points
    }
}

private struct SVGPathParser {
    private enum Token {
        case command(Character)
        case number(CGFloat)
    }

    let pathData: String
    let size: CGSize
    let viewBoxSize: CGFloat

    private var tokens: [Token] = []
    private var index = 0
    private var path = Path()
    private var currentPoint = CGPoint.zero
    private var subpathStart = CGPoint.zero
    private var lastCommand: Character?
    private var lastCubicControl: CGPoint?
    private var lastQuadControl: CGPoint?
    private(set) var firstCanvasPoint: CGPoint?
    private(set) var lastCanvasPoint: CGPoint?
    private(set) var sampledCanvasPoints: [CGPoint] = []

    init(pathData: String, size: CGSize, viewBoxSize: CGFloat) {
        self.pathData = pathData
        self.size = size
        self.viewBoxSize = viewBoxSize
    }

    mutating func parse() -> Path {
        tokens = tokenize(pathData)

        while index < tokens.count {
            let command = consumeCommand() ?? lastCommand
            guard let command else { break }

            lastCommand = command
            parse(command)
        }

        return path
    }

    private mutating func parse(_ command: Character) {
        switch command {
        case "M", "m":
            parseMove(command)
        case "L", "l":
            parseLine(command)
        case "H", "h":
            parseHorizontalLine(command)
        case "V", "v":
            parseVerticalLine(command)
        case "C", "c":
            parseCubic(command)
        case "S", "s":
            parseSmoothCubic(command)
        case "Q", "q":
            parseQuad(command)
        case "T", "t":
            parseSmoothQuad(command)
        case "Z", "z":
            path.closeSubpath()
            currentPoint = subpathStart
            resetControls()
        default:
            index += 1
        }
    }

    private mutating func parseMove(_ command: Character) {
        guard let point = consumePoint(relative: command == "m") else { return }
        let firstPoint = canvasPoint(point)
        path.move(to: firstPoint)
        recordCanvasPoint(firstPoint)
        currentPoint = point
        subpathStart = point
        resetControls()

        while let point = consumePoint(relative: command == "m") {
            let nextPoint = canvasPoint(point)
            path.addLine(to: nextPoint)
            recordCanvasPoint(nextPoint)
            currentPoint = point
        }
    }

    private mutating func parseLine(_ command: Character) {
        while let point = consumePoint(relative: command == "l") {
            let previousPoint = canvasPoint(currentPoint)
            let nextPoint = canvasPoint(point)
            path.addLine(to: nextPoint)
            recordLine(from: previousPoint, to: nextPoint)
            currentPoint = point
            resetControls()
        }
    }

    private mutating func parseHorizontalLine(_ command: Character) {
        while let x = consumeNumber() {
            let nextX = command == "h" ? currentPoint.x + x : x
            let previousPoint = canvasPoint(currentPoint)
            currentPoint = CGPoint(x: nextX, y: currentPoint.y)
            let nextPoint = canvasPoint(currentPoint)
            path.addLine(to: nextPoint)
            recordLine(from: previousPoint, to: nextPoint)
            resetControls()
        }
    }

    private mutating func parseVerticalLine(_ command: Character) {
        while let y = consumeNumber() {
            let nextY = command == "v" ? currentPoint.y + y : y
            let previousPoint = canvasPoint(currentPoint)
            currentPoint = CGPoint(x: currentPoint.x, y: nextY)
            let nextPoint = canvasPoint(currentPoint)
            path.addLine(to: nextPoint)
            recordLine(from: previousPoint, to: nextPoint)
            resetControls()
        }
    }

    private mutating func parseCubic(_ command: Character) {
        while let control1 = consumePoint(relative: command == "c"),
              let control2 = consumePoint(relative: command == "c"),
              let endPoint = consumePoint(relative: command == "c") {
            let canvasStartPoint = canvasPoint(currentPoint)
            let canvasControl1 = canvasPoint(control1)
            let canvasControl2 = canvasPoint(control2)
            let canvasEndPoint = canvasPoint(endPoint)
            path.addCurve(to: canvasEndPoint, control1: canvasControl1, control2: canvasControl2)
            recordCubicCurve(from: canvasStartPoint, control1: canvasControl1, control2: canvasControl2, to: canvasEndPoint)
            currentPoint = endPoint
            lastCubicControl = control2
            lastQuadControl = nil
        }
    }

    private mutating func parseSmoothCubic(_ command: Character) {
        while let control2 = consumePoint(relative: command == "s"),
              let endPoint = consumePoint(relative: command == "s") {
            let control1 = reflectedControlPoint(lastCubicControl)
            let canvasStartPoint = canvasPoint(currentPoint)
            let canvasControl1 = canvasPoint(control1)
            let canvasControl2 = canvasPoint(control2)
            let canvasEndPoint = canvasPoint(endPoint)
            path.addCurve(to: canvasEndPoint, control1: canvasControl1, control2: canvasControl2)
            recordCubicCurve(from: canvasStartPoint, control1: canvasControl1, control2: canvasControl2, to: canvasEndPoint)
            currentPoint = endPoint
            lastCubicControl = control2
            lastQuadControl = nil
        }
    }

    private mutating func parseQuad(_ command: Character) {
        while let control = consumePoint(relative: command == "q"),
              let endPoint = consumePoint(relative: command == "q") {
            let canvasStartPoint = canvasPoint(currentPoint)
            let canvasControl = canvasPoint(control)
            let canvasEndPoint = canvasPoint(endPoint)
            path.addQuadCurve(to: canvasEndPoint, control: canvasControl)
            recordQuadCurve(from: canvasStartPoint, control: canvasControl, to: canvasEndPoint)
            currentPoint = endPoint
            lastQuadControl = control
            lastCubicControl = nil
        }
    }

    private mutating func parseSmoothQuad(_ command: Character) {
        while let endPoint = consumePoint(relative: command == "t") {
            let control = reflectedControlPoint(lastQuadControl)
            let canvasStartPoint = canvasPoint(currentPoint)
            let canvasControl = canvasPoint(control)
            let canvasEndPoint = canvasPoint(endPoint)
            path.addQuadCurve(to: canvasEndPoint, control: canvasControl)
            recordQuadCurve(from: canvasStartPoint, control: canvasControl, to: canvasEndPoint)
            currentPoint = endPoint
            lastQuadControl = control
            lastCubicControl = nil
        }
    }

    private mutating func consumeCommand() -> Character? {
        guard index < tokens.count else { return nil }

        if case .command(let command) = tokens[index] {
            index += 1
            return command
        }

        return nil
    }

    private mutating func consumeNumber() -> CGFloat? {
        guard index < tokens.count else { return nil }

        if case .number(let number) = tokens[index] {
            index += 1
            return number
        }

        return nil
    }

    private mutating func consumePoint(relative: Bool) -> CGPoint? {
        guard let x = consumeNumber(), let y = consumeNumber() else {
            return nil
        }

        if relative {
            return CGPoint(x: currentPoint.x + x, y: currentPoint.y + y)
        }

        return CGPoint(x: x, y: y)
    }

    private func canvasPoint(_ point: CGPoint) -> CGPoint {
        CGPoint(
            x: point.x / viewBoxSize * size.width,
            y: point.y / viewBoxSize * size.height
        )
    }

    private mutating func recordCanvasPoint(_ point: CGPoint) {
        if firstCanvasPoint == nil {
            firstCanvasPoint = point
        }
        lastCanvasPoint = point
        sampledCanvasPoints.append(point)
    }

    private mutating func recordLine(from startPoint: CGPoint, to endPoint: CGPoint) {
        for index in 1...12 {
            let progress = CGFloat(index) / 12
            recordCanvasPoint(CGPoint(
                x: startPoint.x + (endPoint.x - startPoint.x) * progress,
                y: startPoint.y + (endPoint.y - startPoint.y) * progress
            ))
        }
    }

    private mutating func recordQuadCurve(from startPoint: CGPoint, control: CGPoint, to endPoint: CGPoint) {
        for index in 1...16 {
            let t = CGFloat(index) / 16
            let oneMinusT = 1 - t
            recordCanvasPoint(CGPoint(
                x: oneMinusT * oneMinusT * startPoint.x + 2 * oneMinusT * t * control.x + t * t * endPoint.x,
                y: oneMinusT * oneMinusT * startPoint.y + 2 * oneMinusT * t * control.y + t * t * endPoint.y
            ))
        }
    }

    private mutating func recordCubicCurve(from startPoint: CGPoint, control1: CGPoint, control2: CGPoint, to endPoint: CGPoint) {
        for index in 1...20 {
            let t = CGFloat(index) / 20
            let oneMinusT = 1 - t
            recordCanvasPoint(CGPoint(
                x: oneMinusT * oneMinusT * oneMinusT * startPoint.x
                    + 3 * oneMinusT * oneMinusT * t * control1.x
                    + 3 * oneMinusT * t * t * control2.x
                    + t * t * t * endPoint.x,
                y: oneMinusT * oneMinusT * oneMinusT * startPoint.y
                    + 3 * oneMinusT * oneMinusT * t * control1.y
                    + 3 * oneMinusT * t * t * control2.y
                    + t * t * t * endPoint.y
            ))
        }
    }

    private func reflectedControlPoint(_ controlPoint: CGPoint?) -> CGPoint {
        guard let controlPoint else { return currentPoint }

        return CGPoint(
            x: currentPoint.x * 2 - controlPoint.x,
            y: currentPoint.y * 2 - controlPoint.y
        )
    }

    private mutating func resetControls() {
        lastCubicControl = nil
        lastQuadControl = nil
    }

    private func tokenize(_ string: String) -> [Token] {
        let pattern = #"([MmLlHhVvCcSsQqTtZz])|([-+]?(?:\d*\.\d+|\d+\.?)(?:[eE][-+]?\d+)?)"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return []
        }

        let range = NSRange(string.startIndex..<string.endIndex, in: string)
        return regex.matches(in: string, range: range).compactMap { match in
            if let commandRange = Range(match.range(at: 1), in: string),
               let command = string[commandRange].first {
                return .command(command)
            }

            if let numberRange = Range(match.range(at: 2), in: string),
               let number = Double(string[numberRange]) {
                return .number(CGFloat(number))
            }

            return nil
        }
    }
}
