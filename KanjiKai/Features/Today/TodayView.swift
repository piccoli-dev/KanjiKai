//
//  TodayView.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 27/05/2026.
//

import SwiftUI

struct TodayView: View {
    @Environment(LearningProgressStore.self) private var progressStore

    private let user = AppUser.current

    private var stats: [ProgressStat] {
        progressStore.progressStats(for: user, totalKanjiCount: LocalKanjiDatabase.n5Kanji.count)
    }

    private var recentlyLearnedKanji: [KanjiItem] {
        progressStore.recentlyLearnedKanji(from: LocalKanjiDatabase.n5Kanji)
    }

    private var nextTrainingKanji: KanjiItem? {
        progressStore.firstUnlearnedKanji(from: LocalKanjiDatabase.n5Kanji)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Hi, \(user.name)")
                        .font(KanjiKaiFont.bold(34, relativeTo: .largeTitle))
                        .foregroundStyle(Color.primaryBrown)

                    Text("Ready for today's kanji practice?")
                        .font(KanjiKaiFont.regular(18))
                        .foregroundStyle(Color.secondaryBrown)
                }

                mascotCard
                dailyPlanCard

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("Your progress")

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {
                        ForEach(Array(stats.enumerated()), id: \.element.id) { index, stat in
                            ProgressStatCard(stat: stat, accentColor: progressAccent(for: index))
                        }
                    }
                }

                if !recentlyLearnedKanji.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader("Recently learned", actionTitle: "See all")

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(recentlyLearnedKanji) { item in
                                    KanjiCard(item: item)
                                        .frame(width: 132)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(Color.creamBG.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }

    private var mascotCard: some View {
        YukiCard(backgroundColor: Color.apricot.opacity(0.7)) {
            HStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(Color.warmWhite)
                        .frame(width: 92, height: 92)

                    Text("鳥")
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Small steps, big kanji")
                        .font(KanjiKaiFont.bold(23, relativeTo: .title3))
                        .foregroundStyle(Color.primaryBrown)

                    Text("A gentle review keeps every character familiar.")
                        .font(KanjiKaiFont.regular(15))
                        .foregroundStyle(Color.secondaryBrown)
                }

                Spacer()
            }
        }
    }

    private var dailyPlanCard: some View {
        YukiCard(backgroundColor: Color.warmWhite) {
            VStack(alignment: .leading, spacing: 16) {
                SectionHeader("Today's plan")

                VStack(alignment: .leading, spacing: 10) {
                    planRow("Review \(15) kanji", icon: "checkmark.circle.fill", color: .sage)
                    planRow("Learn \(5) new kanji", icon: "sparkles", color: .apricot)
                    planRow("Practice \(3) difficult kanji", icon: "pencil.and.outline", color: .coral)
                }

                if let nextTrainingKanji {
                    NavigationLink {
                        KanjiTrainingView(kanji: nextTrainingKanji)
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "play.fill")
                            Text("Start training")
                                .font(KanjiKaiFont.semiBold(17))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .foregroundStyle(Color.warmWhite)
                        .background(Color.primaryBrown)
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                } else {
                    Text("All kanji learned")
                        .font(KanjiKaiFont.semiBold(17))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .foregroundStyle(Color.secondaryBrown)
                        .background(Color.softGray.opacity(0.35))
                        .clipShape(Capsule())
                }
            }
        }
    }

    private func planRow(_ title: String, icon: String, color: Color) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.primaryBrown)
                .frame(width: 32, height: 32)
                .background(color.opacity(0.8))
                .clipShape(Circle())

            Text(title)
                .font(KanjiKaiFont.medium(16))
                .foregroundStyle(Color.primaryBrown)
        }
    }

    private func progressAccent(for index: Int) -> Color {
        [Color.sky, Color.coral, Color.sage][index % 3]
    }
}

#Preview {
    NavigationStack {
        TodayView()
            .environment(LearningProgressStore())
    }
}
