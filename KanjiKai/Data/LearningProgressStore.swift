//
//  LearningProgressStore.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 29/05/2026.
//

import Foundation
import Observation

@Observable
final class LearningProgressStore {
    private enum Keys {
        static let completedKanji = "learningProgress.completedKanji"
    }

    private let userDefaults: UserDefaults
    private var completedKanji: [Int: Date]

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.completedKanji = Self.loadCompletedKanji(from: userDefaults)
    }

    func isCompleted(_ kanji: KanjiItem) -> Bool {
        completedKanji[kanji.order] != nil
    }

    func completionDate(for kanji: KanjiItem) -> Date? {
        completedKanji[kanji.order]
    }

    var learnedKanjiCount: Int {
        completedKanji.count
    }

    var lastKanjiLearnedDate: Date? {
        completedKanji.values.max()
    }

    var currentStreakInDays: Int {
        currentStreakInDays(calendar: .current, today: .now)
    }

    func progressStats(for user: AppUser, totalKanjiCount: Int) -> [ProgressStat] {
        [
            ProgressStat(title: "Current streak", value: "\(currentStreakInDays)", subtitle: "days"),
            ProgressStat(title: "Level progress", value: user.localizedLevel, subtitle: "Level"),
            ProgressStat(title: "Kanji learned", value: "\(learnedKanjiCount)/\(totalKanjiCount)", subtitle: "beginner path")
        ]
    }

    func profileStats(totalKanjiCount: Int) -> [ProgressStat] {
        [
            ProgressStat(title: "Total kanji learned", value: "\(learnedKanjiCount)", subtitle: String(localized: "of \(totalKanjiCount)")),
            ProgressStat(title: "Current streak", value: "\(currentStreakInDays)", subtitle: "days"),
            ProgressStat(title: "Review accuracy", value: "92%", subtitle: "this week")
        ]
    }

    func kanjiWithProgress(from kanji: [KanjiItem]) -> [KanjiItem] {
        kanji.map { item in
            item.withLearningProgress(completionDate: completedKanji[item.order])
        }
    }

    func recentlyLearnedKanji(from kanji: [KanjiItem]) -> [KanjiItem] {
        kanjiWithProgress(from: kanji)
            .filter(\.isCompleted)
            .sorted { lhs, rhs in
                (lhs.completionDate ?? .distantPast) > (rhs.completionDate ?? .distantPast)
            }
    }

    func firstUnlearnedKanji(from kanji: [KanjiItem]) -> KanjiItem? {
        kanjiWithProgress(from: kanji)
            .sorted { $0.order < $1.order }
            .first { !$0.isCompleted }
    }

    func markCompleted(_ kanji: KanjiItem, at date: Date = .now) {
        guard completedKanji[kanji.order] == nil else { return }
        completedKanji[kanji.order] = date
        save()
    }

    private func save() {
        let payload = Dictionary(uniqueKeysWithValues: completedKanji.map { order, date in
            (String(order), date.timeIntervalSince1970)
        })
        userDefaults.set(payload, forKey: Keys.completedKanji)
    }

    private func currentStreakInDays(calendar: Calendar, today: Date) -> Int {
        let learnedDays = Set(completedKanji.values.map { calendar.startOfDay(for: $0) })
        guard !learnedDays.isEmpty else { return 0 }

        var day = calendar.startOfDay(for: today)
        if !learnedDays.contains(day) {
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: day),
                  learnedDays.contains(yesterday) else {
                return 0
            }
            day = yesterday
        }

        var streak = 0
        while learnedDays.contains(day) {
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: day) else {
                break
            }
            day = previousDay
        }

        return streak
    }

    private static func loadCompletedKanji(from userDefaults: UserDefaults) -> [Int: Date] {
        guard let payload = userDefaults.dictionary(forKey: Keys.completedKanji) as? [String: TimeInterval] else {
            return [:]
        }

        return Dictionary(uniqueKeysWithValues: payload.compactMap { key, timestamp in
            guard let order = Int(key) else { return nil }
            return (order, Date(timeIntervalSince1970: timestamp))
        })
    }
}
