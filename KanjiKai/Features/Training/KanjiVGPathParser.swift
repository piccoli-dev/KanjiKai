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
              let pathData = KanjiVGLoader.pathData(fileName: fileName),
              pathData.count == kanji.trainingStrokes.count else {
            return kanji.trainingStrokes
        }

        return zip(kanji.trainingStrokes, pathData).map { stroke, pathData in
            stroke.withSVGPathData(pathData)
        }
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
        path.move(to: canvasPoint(point))
        currentPoint = point
        subpathStart = point
        resetControls()

        while let point = consumePoint(relative: command == "m") {
            path.addLine(to: canvasPoint(point))
            currentPoint = point
        }
    }

    private mutating func parseLine(_ command: Character) {
        while let point = consumePoint(relative: command == "l") {
            path.addLine(to: canvasPoint(point))
            currentPoint = point
            resetControls()
        }
    }

    private mutating func parseHorizontalLine(_ command: Character) {
        while let x = consumeNumber() {
            let nextX = command == "h" ? currentPoint.x + x : x
            currentPoint = CGPoint(x: nextX, y: currentPoint.y)
            path.addLine(to: canvasPoint(currentPoint))
            resetControls()
        }
    }

    private mutating func parseVerticalLine(_ command: Character) {
        while let y = consumeNumber() {
            let nextY = command == "v" ? currentPoint.y + y : y
            currentPoint = CGPoint(x: currentPoint.x, y: nextY)
            path.addLine(to: canvasPoint(currentPoint))
            resetControls()
        }
    }

    private mutating func parseCubic(_ command: Character) {
        while let control1 = consumePoint(relative: command == "c"),
              let control2 = consumePoint(relative: command == "c"),
              let endPoint = consumePoint(relative: command == "c") {
            path.addCurve(
                to: canvasPoint(endPoint),
                control1: canvasPoint(control1),
                control2: canvasPoint(control2)
            )
            currentPoint = endPoint
            lastCubicControl = control2
            lastQuadControl = nil
        }
    }

    private mutating func parseSmoothCubic(_ command: Character) {
        while let control2 = consumePoint(relative: command == "s"),
              let endPoint = consumePoint(relative: command == "s") {
            let control1 = reflectedControlPoint(lastCubicControl)
            path.addCurve(
                to: canvasPoint(endPoint),
                control1: canvasPoint(control1),
                control2: canvasPoint(control2)
            )
            currentPoint = endPoint
            lastCubicControl = control2
            lastQuadControl = nil
        }
    }

    private mutating func parseQuad(_ command: Character) {
        while let control = consumePoint(relative: command == "q"),
              let endPoint = consumePoint(relative: command == "q") {
            path.addQuadCurve(to: canvasPoint(endPoint), control: canvasPoint(control))
            currentPoint = endPoint
            lastQuadControl = control
            lastCubicControl = nil
        }
    }

    private mutating func parseSmoothQuad(_ command: Character) {
        while let endPoint = consumePoint(relative: command == "t") {
            let control = reflectedControlPoint(lastQuadControl)
            path.addQuadCurve(to: canvasPoint(endPoint), control: canvasPoint(control))
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
