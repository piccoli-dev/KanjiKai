//
//  KanjiDrawingCanvas.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 28/05/2026.
//

import SwiftUI

struct KanjiDrawingCanvas: View {
    let guideCharacter: String
    let strokes: [KanjiStroke]
    let currentStrokeIndex: Int
    let completedPaths: [[CGPoint]]
    let currentPath: [CGPoint]
    let guideMode: KanjiTrainingGuideMode
    let onDrawChanged: ([CGPoint]) -> Void
    let onDrawEnded: ([CGPoint]) -> Void

    var body: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, proxy.size.height)
            let drawingSize = CGSize(width: side, height: side)

            ZStack {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color.creamCard)

                subtleGrid(in: drawingSize)

                if guideMode.showsFullGuide {
                    fullGuide(in: drawingSize)
                }

                if let currentStroke = strokes[safe: currentStrokeIndex],
                   guideMode.showsDirectionHelp {
                    directionGuide(for: currentStroke, in: drawingSize)
                }

                drawnPaths(in: drawingSize)
            }
            .frame(width: side, height: side)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(Color.sage.opacity(0.5), lineWidth: 2)
            )
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        onDrawChanged([value.location.normalized(in: drawingSize)])
                    }
                    .onEnded { value in
                        onDrawEnded([value.location.normalized(in: drawingSize)])
                    }
            )
            .onChange(of: currentPath) { _, _ in }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func subtleGrid(in size: CGSize) -> some View {
        Path { path in
            path.move(to: CGPoint(x: size.width * 0.5, y: size.height * 0.12))
            path.addLine(to: CGPoint(x: size.width * 0.5, y: size.height * 0.88))
            path.move(to: CGPoint(x: size.width * 0.12, y: size.height * 0.5))
            path.addLine(to: CGPoint(x: size.width * 0.88, y: size.height * 0.5))
        }
        .stroke(Color.softGray.opacity(0.28), style: StrokeStyle(lineWidth: 1.5, dash: [8, 10]))
    }

    private func fullGuide(in size: CGSize) -> some View {
        ZStack {
            ForEach(strokes) { stroke in
                strokePath(for: stroke, in: size)
                    .stroke(Color.primaryBrown.opacity(0.18), style: StrokeStyle(lineWidth: 28, lineCap: .round, lineJoin: .round))
            }

            if let currentStroke = strokes[safe: currentStrokeIndex] {
                strokePath(for: currentStroke, in: size)
                    .stroke(Color.apricot.opacity(0.9), style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round))
            }
        }
    }

    private func characterGuide(in size: CGSize) -> some View {
        Text(guideCharacter)
            .font(.system(size: size.width * 0.76, weight: .bold, design: .rounded))
            .foregroundStyle(Color.primaryBrown.opacity(0.16))
            .frame(width: size.width, height: size.height)
            .overlay {
                if let currentStroke = strokes[safe: currentStrokeIndex] {
                    strokePath(for: currentStroke, in: size)
                        .stroke(Color.apricot.opacity(0.85), style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                }
            }
    }

    private func directionGuide(for stroke: KanjiStroke, in size: CGSize) -> some View {
        ZStack {
            Circle()
                .fill(Color.coral)
                .frame(width: 18, height: 18)
                .position(stroke.startPoint.denormalized(in: size))

            strokePath(for: stroke, in: size)
                .stroke(Color.fujiBlue.opacity(0.8), style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round, dash: [10, 8]))

            Image(systemName: "arrowtriangle.right.fill")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.fujiBlue)
                .rotationEffect(arrowRotation(for: stroke))
                .position(stroke.endPoint.denormalized(in: size))
        }
    }

    private func drawnPaths(in size: CGSize) -> some View {
        ZStack {
            ForEach(Array(completedPaths.enumerated()), id: \.offset) { _, pathPoints in
                userPath(from: pathPoints, in: size)
                    .stroke(Color.primaryBrown, style: StrokeStyle(lineWidth: 14, lineCap: .round, lineJoin: .round))
            }

            userPath(from: currentPath, in: size)
                .stroke(Color.primaryBrown.opacity(0.9), style: StrokeStyle(lineWidth: 14, lineCap: .round, lineJoin: .round))
        }
    }

    private func strokePath(for stroke: KanjiStroke, in size: CGSize) -> Path {
        if let svgPathData = stroke.svgPathData {
            return KanjiVGPathParser.path(from: svgPathData, in: size)
        }

        var path = Path()

        if let commands = stroke.guideCommands {
            for command in commands {
                switch command {
                case .move(let point):
                    path.move(to: point.denormalized(in: size))
                case .line(let point):
                    path.addLine(to: point.denormalized(in: size))
                case .quadCurve(let point, let control):
                    path.addQuadCurve(
                        to: point.denormalized(in: size),
                        control: control.denormalized(in: size)
                    )
                }
            }

            return path
        }

        let points = stroke.guidePoints.map { $0.denormalized(in: size) }

        guard let firstPoint = points.first else { return path }
        path.move(to: firstPoint)

        for point in points.dropFirst() {
            path.addLine(to: point)
        }

        return path
    }

    private func userPath(from points: [CGPoint], in size: CGSize) -> Path {
        var path = Path()
        let points = points.map { $0.denormalized(in: size) }

        guard let firstPoint = points.first else { return path }
        path.move(to: firstPoint)

        for point in points.dropFirst() {
            path.addLine(to: point)
        }

        return path
    }

    private func arrowRotation(for stroke: KanjiStroke) -> Angle {
        if let angle = finalSegmentAngle(for: stroke) {
            return angle
        }

        switch stroke.direction {
        case .topToBottom, .rightThenDown:
            return .degrees(90)
        case .leftToRight, .downThenRight:
            return .degrees(0)
        }
    }

    private func finalSegmentAngle(for stroke: KanjiStroke) -> Angle? {
        let points = stroke.guidePoints
        guard let endPoint = points.last else { return nil }

        for startPoint in points.dropLast().reversed() {
            let xDistance = endPoint.x - startPoint.x
            let yDistance = endPoint.y - startPoint.y

            guard hypot(xDistance, yDistance) > 0.001 else { continue }

            return .radians(atan2(yDistance, xDistance))
        }

        return nil
    }
}

private extension CGPoint {
    func denormalized(in size: CGSize) -> CGPoint {
        CGPoint(x: x * size.width, y: y * size.height)
    }

    func normalized(in size: CGSize) -> CGPoint {
        CGPoint(
            x: min(max(x / max(size.width, 1), 0), 1),
            y: min(max(y / max(size.height, 1), 0), 1)
        )
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
