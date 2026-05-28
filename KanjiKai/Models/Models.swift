//
//  Models.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 27/05/2026.
//

import SwiftUI

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
    let character: String
    let meaning: String
    let reading: String
    let category: String
    let masteryLevel: MasteryLevel
    let isFavorite: Bool

    init(
        id: UUID = UUID(),
        character: String,
        meaning: String,
        reading: String,
        category: String,
        masteryLevel: MasteryLevel,
        isFavorite: Bool
    ) {
        self.id = id
        self.character = character
        self.meaning = meaning
        self.reading = reading
        self.category = category
        self.masteryLevel = masteryLevel
        self.isFavorite = isFavorite
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
