//
//  LibraryViews.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 27/05/2026.
//

import SwiftUI

enum LibraryFilter: String, CaseIterable, Identifiable {
    case kanji = "Kanji"
    case vocab = "Vocab"
    case radicals = "Radicals"
    case favorites = "Favorites"

    var id: String { self.rawValue }

    var localized: String {
        switch self {
        case .kanji: return String(localized: "Kanji")
        case .vocab: return String(localized: "Vocab")
        case .radicals: return String(localized: "Radicals")
        case .favorites: return String(localized: "Favorites")
        }
    }
}

struct LibraryView: View {
    @Environment(LearningProgressStore.self) private var progressStore

    @State private var searchText = ""
    @State private var selectedFilter: LibraryFilter = .kanji

    private let filters = LibraryFilter.allCases

    private var kanji: [KanjiItem] {
        progressStore.kanjiWithProgress(from: MockYukimojiData.libraryKanji)
    }

    private var filteredKanji: [KanjiItem] {
        kanji.filter { item in
            let matchesSearch = searchText.isEmpty
                || item.character.localizedCaseInsensitiveContains(searchText)
                || item.localizedMeaning.localizedCaseInsensitiveContains(searchText)
                || item.reading.localizedCaseInsensitiveContains(searchText)
                || item.category.localizedCaseInsensitiveContains(searchText)

            let matchesFilter = selectedFilter != .favorites || item.isFavorite
            return matchesSearch && matchesFilter
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Library")
                    .font(KanjiKaiFont.bold(34, relativeTo: .largeTitle))
                    .foregroundStyle(Color.primaryBrown)

                filterChips
                masteryLegend

                SectionHeader("Kanji Data")

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 104), spacing: 12)], spacing: 12) {
                    ForEach(filteredKanji) { item in
                        NavigationLink(value: item) {
                            KanjiCard(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(20)
        }
        .background(Color.creamBG.ignoresSafeArea())
        .searchable(text: $searchText, prompt: "Search Kanji, Keyword...")
        .navigationDestination(for: KanjiItem.self) { item in
            KanjiDetailView(item: item)
        }
    }

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(filters.enumerated()), id: \.element.id) { index, filter in
                    FilterChip(
                        title: filter.localized,
                        isSelected: selectedFilter == filter,
                        color: chipColor(for: index)
                    ) {
                        selectedFilter = filter
                    }
                }
            }
        }
    }

    private var masteryLegend: some View {
        YukiCard(backgroundColor: Color.warmWhite) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Mastery")
                    .font(KanjiKaiFont.semiBold(18))
                    .foregroundStyle(Color.primaryBrown)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 126), spacing: 8)], spacing: 8) {
                    ForEach(MasteryLevel.allCases) { level in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(level.color.color)
                                .frame(width: 12, height: 12)

                            Text(level.rawValue)
                                .font(KanjiKaiFont.regular(14))
                                .foregroundStyle(Color.secondaryBrown)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }

    private func chipColor(for index: Int) -> Color {
        [Color.sky, Color.sage, Color.coral, Color.apricot][index % 4]
    }
}

struct KanjiDetailView: View {
    let item: KanjiItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                YukiCard(backgroundColor: item.masteryLevel.color.color.opacity(0.72)) {
                    VStack(spacing: 12) {
                        Text(item.character)
                            .font(.system(size: 112, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.charcoal)

                        Text(item.localizedMeaning)
                            .font(KanjiKaiFont.bold(30, relativeTo: .title))
                            .foregroundStyle(Color.primaryBrown)

                        Text(item.reading)
                            .font(KanjiKaiFont.regular(20))
                            .foregroundStyle(Color.secondaryBrown)
                    }
                    .frame(maxWidth: .infinity)
                }

                detailRows

                detailSection(
                    title: "Mnemonic story",
                    text: "Imagine a gentle guide pointing out this kanji in a warm lesson book. The shape becomes easier to remember when it has a tiny story attached."
                )

                detailSection(
                    title: "Example words",
                    text: exampleWordsText
                )

                detailSection(
                    title: "Practice",
                    text: "Practice cards, writing prompts, and review history will connect here later."
                )

                practiceButton
            }
            .padding(20)
        }
        .background(Color.creamBG.ignoresSafeArea())
        .navigationTitle(item.localizedMeaning)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var detailRows: some View {
        YukiCard(backgroundColor: Color.warmWhite) {
            VStack(spacing: 12) {
                infoRow(title: "Category", value: String(localized: LocalizedStringResource(stringLiteral: item.category)))
                infoRow(title: "Order", value: "#\(item.order)")
                infoRow(title: "Mastery", value: String(localized: LocalizedStringResource(stringLiteral: item.masteryLevel.rawValue)))
                infoRow(title: "Favorite", value: item.isFavorite ? "Yes" : "No")
                infoRow(title: "Completed", value: item.isCompleted ? "Yes" : "No")
            }
        }
    }

    private var exampleWordsText: String {
        guard !item.exampleWords.isEmpty else {
            return "Example words will appear here as this kanji receives study data."
        }

        return item.exampleWords
            .map { "\($0.word) — \($0.localizedMeaning)" }
            .joined(separator: "\n")
    }

    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(KanjiKaiFont.medium(15))
                .foregroundStyle(Color.secondaryBrown)

            Spacer()

            Text(value)
                .font(KanjiKaiFont.semiBold(16))
                .foregroundStyle(Color.primaryBrown)
        }
    }

    private func detailSection(title: String, text: String) -> some View {
        YukiCard(backgroundColor: Color.warmWhite) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(KanjiKaiFont.bold(22, relativeTo: .title3))
                    .foregroundStyle(Color.primaryBrown)

                Text(text)
                    .font(KanjiKaiFont.regular(16))
                    .foregroundStyle(Color.secondaryBrown)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var practiceButton: some View {
        Group {
            if item.trainingStrokes.isEmpty && item.kanjiVGFileName == nil {
                Text("Stroke guide coming soon")
                    .font(KanjiKaiFont.semiBold(16))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .foregroundStyle(Color.secondaryBrown)
                    .background(Color.softGray.opacity(0.35))
                    .clipShape(Capsule())
            } else {
                NavigationLink {
                    KanjiTrainingView(kanji: item)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "pencil.and.scribble")
                        Text("Practice \(item.character)")
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
        }
    }
}

#Preview {
    NavigationStack {
        LibraryView()
            .environment(LearningProgressStore())
    }
}
