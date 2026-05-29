//
//  TrainingViews.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 27/05/2026.
//

import SwiftUI

struct TrainingView: View {
    private let tasks = MockYukimojiData.dailyTrainingTasks

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Training Ground")
                    .font(KanjiKaiFont.bold(34, relativeTo: .largeTitle))
                    .foregroundStyle(Color.primaryBrown)

                Text("Learn, review, and rebuild confidence with short practice sessions.")
                    .font(KanjiKaiFont.regular(17))
                    .foregroundStyle(Color.secondaryBrown)

                VStack(spacing: 12) {
                    ForEach(tasks) { task in
                        NavigationLink(value: task) {
                            TrainingTaskCard(task: task)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(20)
        }
        .background(Color.creamBG.ignoresSafeArea())
        .navigationDestination(for: TrainingTask.self) { task in
            TrainingDetailView(task: task)
        }
    }
}

struct TrainingDetailView: View {
    let task: TrainingTask

    private var isFlashcards: Bool {
        task.title == "Flashcards"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(task.title)
                        .font(KanjiKaiFont.bold(34, relativeTo: .largeTitle))
                        .foregroundStyle(Color.primaryBrown)

                    Text(task.subtitle)
                        .font(KanjiKaiFont.regular(17))
                        .foregroundStyle(Color.secondaryBrown)
                }

                if isFlashcards {
                    flashcardPreview
                } else {
                    placeholderPracticeCard
                }

                NavigationLink {
                    KanjiTrainingView(kanji: MockYukimojiData.defaultTrainingKanji)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                        Text("Start")
                            .font(KanjiKaiFont.semiBold(17))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .foregroundStyle(Color.warmWhite)
                    .background(Color.primaryBrown)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding(20)
        }
        .background(Color.creamBG.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }

    private var placeholderPracticeCard: some View {
        YukiCard(backgroundColor: task.accentColor.color.opacity(0.75)) {
            VStack(spacing: 16) {
                Image(systemName: task.icon)
                    .font(.system(size: 46, weight: .semibold))
                    .foregroundStyle(Color.primaryBrown)

                Text("A focused practice flow will live here.")
                    .font(KanjiKaiFont.semiBold(22, relativeTo: .title3))
                    .foregroundStyle(Color.primaryBrown)
                    .multilineTextAlignment(.center)

                Text("For now this screen is ready for navigation, copy, and future lesson logic.")
                    .font(KanjiKaiFont.regular(16))
                    .foregroundStyle(Color.secondaryBrown)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
        }
    }

    private var flashcardPreview: some View {
        YukiCard(backgroundColor: Color.warmWhite) {
            VStack(spacing: 18) {
                Text("余")
                    .font(.system(size: 88, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.charcoal)

                VStack(spacing: 6) {
                    Text("Extra, remaining")
                        .font(KanjiKaiFont.semiBold(22))
                        .foregroundStyle(Color.primaryBrown)

                    Text("よ")
                        .font(KanjiKaiFont.regular(17))
                        .foregroundStyle(Color.secondaryBrown)
                }

                VStack(spacing: 10) {
                    responseButton("Easy", color: .sage)
                    responseButton("Good", color: .mint)
                    responseButton("Hard", color: .terracotta)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
        }
    }

    private func responseButton(_ title: String, color: Color) -> some View {
        Text(title)
            .font(KanjiKaiFont.semiBold(16))
            .foregroundStyle(Color.primaryBrown)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(color.opacity(0.8))
            .clipShape(Capsule())
    }
}

#Preview {
    NavigationStack {
        TrainingView()
    }
}
