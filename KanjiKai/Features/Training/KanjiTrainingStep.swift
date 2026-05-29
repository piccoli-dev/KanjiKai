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
            KanjiTrainingStep(id: 1, title: localized("training.step.title.fullGuidedTracing"), instruction: localized("training.step.instruction.traceHighlighted"), guideMode: .fullGuided),
            KanjiTrainingStep(id: 2, title: localized("training.step.title.fullGuidedTracing"), instruction: localized("training.step.instruction.repeatStrokeOrder"), guideMode: .fullGuided),
            KanjiTrainingStep(id: 3, title: localized("training.step.title.directionPractice"), instruction: localized("training.step.instruction.useStartDot"), guideMode: .directionOnly),
            KanjiTrainingStep(id: 4, title: localized("training.step.title.directionPractice"), instruction: localized("training.step.instruction.followDirectionHints"), guideMode: .directionOnly),
            KanjiTrainingStep(id: 5, title: localized("training.step.title.freehandPractice"), instruction: localized("training.step.instruction.drawFromMemory", kanji.character), guideMode: .freehand),
            KanjiTrainingStep(id: 6, title: localized("training.step.title.freehandPractice"), instruction: localized("training.step.instruction.keepBalanced"), guideMode: .freehand),
            KanjiTrainingStep(id: 7, title: localized("training.step.title.freehandPractice"), instruction: localized("training.step.instruction.calmRhythm"), guideMode: .freehand),
            KanjiTrainingStep(id: 8, title: localized("training.step.title.wordExample"), instruction: localized("training.step.instruction.readingExampleWord", kanji.character), guideMode: .exampleWord(word: examples[safe: 0]?.word ?? kanji.character, meaning: examples[safe: 0]?.localizedMeaning ?? kanji.localizedMeaning)),
            KanjiTrainingStep(id: 9, title: localized("training.step.title.wordExample"), instruction: localized("training.step.instruction.insideAnotherWord", kanji.character), guideMode: .exampleWord(word: examples[safe: 1]?.word ?? kanji.character, meaning: examples[safe: 1]?.localizedMeaning ?? kanji.localizedMeaning)),
            KanjiTrainingStep(id: 10, title: localized("training.step.title.wordExample"), instruction: localized("training.step.instruction.commonDailyWord", kanji.character), guideMode: .exampleWord(word: examples[safe: 2]?.word ?? kanji.character, meaning: examples[safe: 2]?.localizedMeaning ?? kanji.localizedMeaning))
        ]
    }

    private static func localized(_ key: String, _ arguments: CVarArg...) -> String {
        let format = String(localized: LocalizedStringResource(stringLiteral: key))
        return String(format: format, locale: Locale.current, arguments: arguments)
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
