//
//  KanjiStroke.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 28/05/2026.
//

import CoreGraphics
import SwiftUI

enum KanjiStrokeType {
    case vertical
    case horizontal
    case corner
}

enum KanjiStrokeDirection {
    case topToBottom
    case leftToRight
    case rightThenDown
    case downThenRight
}

enum KanjiStrokeGuideCommand: Hashable {
    case move(to: CGPoint)
    case line(to: CGPoint)
    case quadCurve(to: CGPoint, control: CGPoint)
}

struct KanjiStroke: Identifiable, Hashable {
    let id: Int
    let strokeType: KanjiStrokeType
    let startPoint: CGPoint
    let endPoint: CGPoint
    let cornerPoint: CGPoint?
    let direction: KanjiStrokeDirection
    private let customGuidePoints: [CGPoint]?
    let guideCommands: [KanjiStrokeGuideCommand]?

    init(
        id: Int,
        strokeType: KanjiStrokeType,
        startPoint: CGPoint,
        endPoint: CGPoint,
        cornerPoint: CGPoint?,
        direction: KanjiStrokeDirection,
        guidePoints: [CGPoint]? = nil,
        guideCommands: [KanjiStrokeGuideCommand]? = nil
    ) {
        self.id = id
        self.strokeType = strokeType
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.cornerPoint = cornerPoint
        self.direction = direction
        self.customGuidePoints = guidePoints
        self.guideCommands = guideCommands
    }

    var guidePoints: [CGPoint] {
        if let customGuidePoints {
            customGuidePoints
        } else if let cornerPoint {
            [startPoint, cornerPoint, endPoint]
        } else {
            [startPoint, endPoint]
        }
    }
}

enum KanjiStrokeValidator {
    static func validate(
        drawnPoints: [CGPoint],
        stroke: KanjiStroke,
        tolerance: CGFloat = 0.15
    ) -> Bool {
        guard let firstPoint = drawnPoints.first, let lastPoint = drawnPoints.last else {
            return false
        }

        guard firstPoint.distance(to: stroke.startPoint) <= tolerance,
              lastPoint.distance(to: stroke.endPoint) <= tolerance else {
            return false
        }

        switch stroke.direction {
        case .topToBottom:
            return lastPoint.y - firstPoint.y > 0.35 && abs(lastPoint.x - firstPoint.x) < 0.22
        case .leftToRight:
            return lastPoint.x - firstPoint.x > 0.30 && abs(lastPoint.y - firstPoint.y) < 0.18
        case .rightThenDown:
            return validatesRightThenDownStroke(drawnPoints, stroke: stroke, tolerance: tolerance)
        case .downThenRight:
            return validatesDownThenRightStroke(drawnPoints, stroke: stroke, tolerance: tolerance)
        }
    }

    private static func validatesRightThenDownStroke(
        _ drawnPoints: [CGPoint],
        stroke: KanjiStroke,
        tolerance: CGFloat
    ) -> Bool {
        guard let cornerPoint = stroke.cornerPoint else { return false }

        let touchesCorner = drawnPoints.contains { point in
            point.distance(to: cornerPoint) <= tolerance
        }

        guard touchesCorner else { return false }

        let firstPoint = drawnPoints[0]
        let lastPoint = drawnPoints[drawnPoints.count - 1]
        return lastPoint.x - firstPoint.x > 0.25
            && lastPoint.y - firstPoint.y > 0.35
    }

    private static func validatesDownThenRightStroke(
        _ drawnPoints: [CGPoint],
        stroke: KanjiStroke,
        tolerance: CGFloat
    ) -> Bool {
        guard let cornerPoint = stroke.cornerPoint else { return false }

        let touchesCorner = drawnPoints.contains { point in
            point.distance(to: cornerPoint) <= tolerance
        }

        guard touchesCorner else { return false }

        let firstPoint = drawnPoints[0]
        let lastPoint = drawnPoints[drawnPoints.count - 1]
        return lastPoint.y - firstPoint.y > 0.12
            && lastPoint.x - firstPoint.x > 0.12
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let xDistance = x - point.x
        let yDistance = y - point.y
        return sqrt(xDistance * xDistance + yDistance * yDistance)
    }
}
