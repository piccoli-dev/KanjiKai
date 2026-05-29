//
//  KanjiTrainingStep.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 28/05/2026.
//

import Foundation

enum KanjiTrainingGuideMode {
    case fullGuided
    case directionOnly
    case freehand
    case exampleWord(word: String, meaning: String)

    var showsFullGuide: Bool {
        if case .fullGuided = self {
            return true
        }
        return false
    }

    var showsDirectionHelp: Bool {
        switch self {
        case .fullGuided, .directionOnly:
            true
        case .freehand, .exampleWord:
            false
        }
    }
}

struct KanjiTrainingStep: Identifiable {
    let id: Int
    let title: String
    let instruction: String
    let guideMode: KanjiTrainingGuideMode

    static func steps(for kanji: KanjiItem) -> [KanjiTrainingStep] {
        let examples = kanji.exampleWords

        return [
        KanjiTrainingStep(id: 1, title: "Full guided tracing", instruction: "Trace each highlighted stroke in order.", guideMode: .fullGuided),
        KanjiTrainingStep(id: 2, title: "Full guided tracing", instruction: "Repeat the same stroke order with the full guide.", guideMode: .fullGuided),
        KanjiTrainingStep(id: 3, title: "Direction practice", instruction: "Use the start dot and arrow to draw each stroke.", guideMode: .directionOnly),
        KanjiTrainingStep(id: 4, title: "Direction practice", instruction: "Follow the direction hints without the full outline.", guideMode: .directionOnly),
        KanjiTrainingStep(id: 5, title: "Freehand practice", instruction: "Draw 日 from memory, one stroke at a time.", guideMode: .freehand),
        KanjiTrainingStep(id: 6, title: "Freehand practice", instruction: "Keep the kanji balanced inside the practice box.", guideMode: .freehand),
        KanjiTrainingStep(id: 7, title: "Freehand practice", instruction: "Try drawing with a calm, steady rhythm.", guideMode: .freehand),
        KanjiTrainingStep(id: 8, title: "Word example", instruction: "Practice \(kanji.character) while reading this example word.", guideMode: .exampleWord(word: examples[safe: 0]?.word ?? kanji.character, meaning: examples[safe: 0]?.meaning ?? kanji.meaning)),
        KanjiTrainingStep(id: 9, title: "Word example", instruction: "Practice \(kanji.character) inside another word.", guideMode: .exampleWord(word: examples[safe: 1]?.word ?? kanji.character, meaning: examples[safe: 1]?.meaning ?? kanji.meaning)),
        KanjiTrainingStep(id: 10, title: "Word example", instruction: "Practice \(kanji.character) in a common daily word.", guideMode: .exampleWord(word: examples[safe: 2]?.word ?? kanji.character, meaning: examples[safe: 2]?.meaning ?? kanji.meaning))
        ]
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
