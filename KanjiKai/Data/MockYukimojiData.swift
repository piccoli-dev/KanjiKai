//
//  MockYukimojiData.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 27/05/2026.
//

import Foundation

enum MockYukimojiData {
    static let recentlyLearnedKanji: [KanjiItem] = [
        KanjiItem(character: "首", meaning: "Neck", reading: "くび", category: "Body", masteryLevel: .apprentice, isFavorite: false),
        KanjiItem(character: "町", meaning: "Town", reading: "まち", category: "Places", masteryLevel: .adept, isFavorite: true),
        KanjiItem(character: "京", meaning: "Capital", reading: "きょう", category: "Places", masteryLevel: .apprentice, isFavorite: false),
        KanjiItem(character: "花", meaning: "Flower", reading: "はな", category: "Nature", masteryLevel: .sensei, isFavorite: true)
    ]

    static let libraryKanji: [KanjiItem] = [
        KanjiItem(character: "首", meaning: "Neck", reading: "くび", category: "Body", masteryLevel: .apprentice, isFavorite: false),
        KanjiItem(character: "言", meaning: "Say", reading: "いう", category: "Action", masteryLevel: .adept, isFavorite: false),
        KanjiItem(character: "人", meaning: "Person", reading: "ひと", category: "People", masteryLevel: .apprentice, isFavorite: true),
        KanjiItem(character: "見", meaning: "See", reading: "みる", category: "Action", masteryLevel: .adept, isFavorite: false),
        KanjiItem(character: "一", meaning: "One", reading: "いち", category: "Number", masteryLevel: .sensei, isFavorite: false),
        KanjiItem(character: "出", meaning: "Exit", reading: "でる", category: "Action", masteryLevel: .master, isFavorite: true),
        KanjiItem(character: "行", meaning: "Going", reading: "いく", category: "Action", masteryLevel: .sensei, isFavorite: false),
        KanjiItem(character: "大", meaning: "Large", reading: "おおきい", category: "Size", masteryLevel: .master, isFavorite: false),
        KanjiItem(character: "思", meaning: "Think", reading: "おもう", category: "Mind", masteryLevel: .adept, isFavorite: false),
        KanjiItem(character: "何", meaning: "What", reading: "なに", category: "Question", masteryLevel: .sensei, isFavorite: true),
        KanjiItem(character: "今", meaning: "Now", reading: "いま", category: "Time", masteryLevel: .sensei, isFavorite: false),
        KanjiItem(character: "分", meaning: "Part", reading: "ぶん", category: "Concept", masteryLevel: .apprentice, isFavorite: false)
    ]

    static let dailyTrainingTasks: [TrainingTask] = [
        TrainingTask(title: "Review due kanji", subtitle: "Warm up with cards ready for review", icon: "clock.arrow.circlepath", accentColor: .apricot, count: 15),
        TrainingTask(title: "Learn new kanji", subtitle: "Meet a small set of beginner kanji", icon: "sparkles", accentColor: .sage, count: 5),
        TrainingTask(title: "Flashcards", subtitle: "Quick recall with easy feedback", icon: "rectangle.on.rectangle.angled", accentColor: .sky, count: 20),
        TrainingTask(title: "Writing practice", subtitle: "Trace strokes and reinforce shape memory", icon: "pencil.and.scribble", accentColor: .mint, count: 8),
        TrainingTask(title: "Mistakes", subtitle: "Revisit kanji that need extra care", icon: "exclamationmark.bubble.fill", accentColor: .coral, count: 3)
    ]

    static let progressStats: [ProgressStat] = [
        ProgressStat(title: "Current streak", value: "16", subtitle: "days"),
        ProgressStat(title: "Level progress", value: "64", subtitle: "LVL"),
        ProgressStat(title: "Kanji learned", value: "45/100", subtitle: "beginner path")
    ]
}
