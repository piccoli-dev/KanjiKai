//
//  MockYukimojiData.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 27/05/2026.
//

import Foundation

enum MockYukimojiData {
    static let defaultTrainingKanji: KanjiItem = LocalKanjiDatabase.kanji(order: 15) ?? KanjiItem(
        character: "日",
        meaning: "giorno, sole",
        reading: "にち, じつ / ひ, か",
        category: "N5",
        masteryLevel: .apprentice,
        isFavorite: false
    )

    static let recentlyLearnedKanji: [KanjiItem] = [
        LocalKanjiDatabase.kanji(character: "日"),
        LocalKanjiDatabase.kanji(character: "人"),
        LocalKanjiDatabase.kanji(character: "大"),
        LocalKanjiDatabase.kanji(character: "花")
    ].compactMap { $0 }

    static let libraryKanji: [KanjiItem] = LocalKanjiDatabase.n5Kanji

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
