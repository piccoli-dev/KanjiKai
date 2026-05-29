//
//  Models.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 27/05/2026.
//

import SwiftUI

struct KanjiExampleWord: Identifiable, Hashable {
    let id = UUID()
    let word: String
    let meaning: String
}

enum MasteryLevel: String, CaseIterable, Identifiable {
    case apprentice = "Apprentice"
    case adept = "Adept"
    case sensei = "Sensei"
    case master = "Master"

    var id: Self { self }

    var color: AppColor {
        switch self {
        case .apprentice:
            .sky
        case .adept:
            .mint
        case .sensei:
            .fujiBlue
        case .master:
            .coral
        }
    }
}

struct KanjiItem: Identifiable, Hashable {
    let id: UUID
    let order: Int
    let character: String
    let meaning: String
    let reading: String
    let category: String
    let masteryLevel: MasteryLevel
    let isFavorite: Bool
    let isCompleted: Bool
    let completionDate: Date?
    let guideCharacter: String
    let trainingStrokes: [KanjiStroke]
    let exampleWords: [KanjiExampleWord]

    init(
        id: UUID = UUID(),
        order: Int = 0,
        character: String,
        meaning: String,
        reading: String,
        category: String,
        masteryLevel: MasteryLevel,
        isFavorite: Bool,
        isCompleted: Bool = false,
        completionDate: Date? = nil,
        guideCharacter: String? = nil,
        trainingStrokes: [KanjiStroke] = [],
        exampleWords: [KanjiExampleWord] = []
    ) {
        self.id = id
        self.order = order
        self.character = character
        self.meaning = meaning
        self.reading = reading
        self.category = category
        self.masteryLevel = masteryLevel
        self.isFavorite = isFavorite
        self.isCompleted = isCompleted
        self.completionDate = completionDate
        self.guideCharacter = guideCharacter ?? character
        self.trainingStrokes = trainingStrokes
        self.exampleWords = exampleWords
    }
}

struct TrainingTask: Identifiable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let icon: String
    let accentColor: AppColor
    let count: Int

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        icon: String,
        accentColor: AppColor,
        count: Int
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.accentColor = accentColor
        self.count = count
    }
}

struct ProgressStat: Identifiable, Hashable {
    let id: UUID
    let title: String
    let value: String
    let subtitle: String

    init(id: UUID = UUID(), title: String, value: String, subtitle: String) {
        self.id = id
        self.title = title
        self.value = value
        self.subtitle = subtitle
    }
}
