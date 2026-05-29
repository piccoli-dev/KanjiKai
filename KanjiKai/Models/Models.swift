//
//  Models.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 27/05/2026.
//

import SwiftUI

struct AppUser: Hashable {
    let name: String
    let email: String
    let level: String
    let dailyGoal: Int
    let nativeLanguage: String

    static let current = AppUser(
        name: "Francesca",
        email: "kristin@example.com",
        level: "N5",
        dailyGoal: 20,
        nativeLanguage: "English"
    )

    var localizedLevel: String {
        String(localized: LocalizedStringResource(stringLiteral: level))
    }

    var localizedNativeLanguage: String {
        String(localized: LocalizedStringResource(stringLiteral: nativeLanguage))
    }
}

struct KanjiExampleWord: Identifiable, Hashable {
    let id = UUID()
    let word: String
    let meaning: String

    var localizedMeaning: String {
        String(localized: LocalizedStringResource(stringLiteral: meaning))
    }
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
    let kanjiVGFileName: String?
    let trainingStrokes: [KanjiStroke]
    let exampleWords: [KanjiExampleWord]

    var localizedMeaning: String {
        String(localized: LocalizedStringResource(stringLiteral: meaning))
    }

    func withUserState(completionDate: Date?, isFavorite: Bool) -> KanjiItem {
        KanjiItem(
            id: id,
            order: order,
            character: character,
            meaning: meaning,
            reading: reading,
            category: category,
            masteryLevel: completionDate == nil ? masteryLevel : .adept,
            isFavorite: isFavorite,
            isCompleted: completionDate != nil,
            completionDate: completionDate,
            guideCharacter: guideCharacter,
            kanjiVGFileName: kanjiVGFileName,
            trainingStrokes: trainingStrokes,
            exampleWords: exampleWords
        )
    }

    func withLearningProgress(completionDate: Date?) -> KanjiItem {
        withUserState(completionDate: completionDate, isFavorite: isFavorite)
    }

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
        kanjiVGFileName: String? = nil,
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
        self.kanjiVGFileName = kanjiVGFileName
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
