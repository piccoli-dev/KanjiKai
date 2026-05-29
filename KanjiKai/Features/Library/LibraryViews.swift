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

enum LibraryKanjiType: String, CaseIterable, Identifiable {
    case people = "Persone"
    case body = "Corpo"
    case nature = "Natura"
    case time = "Tempo"
    case places = "Luoghi"
    case actions = "Azioni"
    case movement = "Movimento"
    case quantity = "Quantità/numeri"
    case qualities = "Qualità/aggettivi"
    case emotions = "Emozioni/stati"
    case society = "Società/lavoro"
    case communication = "Comunicazione"
    case study = "Studio/conoscenza"

    var id: String { rawValue }

    var localizedTitle: String {
        String(localized: LocalizedStringResource(stringLiteral: rawValue))
    }

    var subtitle: String {
        switch self {
        case .people:
            "persona, ruoli, relazioni"
        case .body:
            "parti del corpo, mente"
        case .nature:
            "ambiente naturale"
        case .time:
            "date, orari, sequenza"
        case .places:
            "posti e istituzioni"
        case .actions:
            "attività/verbi"
        case .movement:
            "direzione e spazio"
        case .quantity:
            "numeri e quantità"
        case .qualities:
            "proprietà"
        case .emotions:
            "stati mentali/emotivi"
        case .society:
            "lavoro, società, istituzioni"
        case .communication:
            "lingua, parole, informazione"
        case .study:
            "scuola e apprendimento"
        }
    }

    var localizedSubtitle: String {
        String(localized: LocalizedStringResource(stringLiteral: subtitle))
    }

    var kanjiCharacters: Set<Character> {
        switch self {
        case .people:
            Set("人子女男友先生")
        case .body:
            Set("目耳手足口心")
        case .nature:
            Set("山川木火水石雨")
        case .time:
            Set("日月年時分今前後")
        case .places:
            Set("学校駅店家国外")
        case .actions:
            Set("行来見聞食飲読書")
        case .movement:
            Set("行来出入上下近遠")
        case .quantity:
            Set("一二三百千万半")
        case .qualities:
            Set("大小新古高安長早")
        case .emotions:
            Set("心思急悪好楽")
        case .society:
            Set("社会仕事働店業")
        case .communication:
            Set("言話語読書聞")
        case .study:
            Set("学校先生教知考")
        }
    }

    func contains(_ item: KanjiItem) -> Bool {
        guard let character = item.character.first else { return false }
        return kanjiCharacters.contains(character)
    }
}

struct LibraryView: View {
    @Environment(LearningProgressStore.self) private var progressStore

    @State private var searchText = ""
    @State private var selectedFilter: LibraryFilter = .kanji
    @State private var isShowingAdvancedFilters = false
    @State private var selectedDifficulty: String?
    @State private var selectedKanjiType: LibraryKanjiType?
    @State private var strokeCountText = ""

    private let filters = LibraryFilter.allCases
    private let difficulties = ["N5", "N4", "N3", "N2", "N1"]

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
            let matchesDifficulty = selectedDifficulty == nil || item.category == selectedDifficulty
            let matchesType = selectedKanjiType?.contains(item) ?? true
            let matchesStrokeCount = strokeCount.map { KanjiVGStrokeProvider.strokes(for: item).count == $0 } ?? true
            return matchesSearch && matchesFilter && matchesDifficulty && matchesType && matchesStrokeCount
        }
    }

    private var strokeCount: Int? {
        Int(strokeCountText.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    private var activeAdvancedFilterCount: Int {
        [selectedDifficulty != nil, selectedKanjiType != nil, strokeCount != nil].filter { $0 }.count
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Library")
                    .font(KanjiKaiFont.bold(34, relativeTo: .largeTitle))
                    .foregroundStyle(Color.primaryBrown)

                searchAndFilterBar
                filterChips

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
        .sheet(isPresented: $isShowingAdvancedFilters) {
            LibraryAdvancedFiltersSheet(
                difficulties: difficulties,
                selectedDifficulty: $selectedDifficulty,
                selectedKanjiType: $selectedKanjiType,
                strokeCountText: $strokeCountText,
                onReset: resetAdvancedFilters
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .navigationDestination(for: KanjiItem.self) { item in
            KanjiDetailView(item: item)
        }
    }

    private var searchAndFilterBar: some View {
        HStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.secondaryBrown.opacity(0.75))

                TextField("Search Kanji, Keyword...", text: $searchText)
                    .font(KanjiKaiFont.regular(16))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.secondaryBrown.opacity(0.6))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 14)
            .frame(height: 46)
            .background(Color.warmWhite)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.softGray.opacity(0.45), lineWidth: 1)
            )

            Button {
                isShowingAdvancedFilters = true
            } label: {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "line.3.horizontal.decrease.circle.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .frame(width: 46, height: 46)
                        .foregroundStyle(Color.primaryBrown)
                        .background(Color.warmWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                    if activeAdvancedFilterCount > 0 {
                        Text("\(activeAdvancedFilterCount)")
                            .font(KanjiKaiFont.bold(11))
                            .foregroundStyle(Color.warmWhite)
                            .frame(width: 18, height: 18)
                            .background(Color.coral)
                            .clipShape(Circle())
                            .offset(x: 5, y: -5)
                    }
                }
            }
            .buttonStyle(.plain)
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

    private func chipColor(for index: Int) -> Color {
        [Color.sky, Color.sage, Color.coral, Color.apricot][index % 4]
    }

    private func resetAdvancedFilters() {
        selectedDifficulty = nil
        selectedKanjiType = nil
        strokeCountText = ""
    }
}

private struct LibraryAdvancedFiltersSheet: View {
    @Environment(\.dismiss) private var dismiss

    let difficulties: [String]
    @Binding var selectedDifficulty: String?
    @Binding var selectedKanjiType: LibraryKanjiType?
    @Binding var strokeCountText: String
    let onReset: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    filterSection(title: "Difficoltà") {
                        chipGrid {
                            filterButton("Tutte", isSelected: selectedDifficulty == nil) {
                                selectedDifficulty = nil
                            }

                            ForEach(difficulties, id: \.self) { difficulty in
                                filterButton(difficulty, isSelected: selectedDifficulty == difficulty) {
                                    selectedDifficulty = difficulty
                                }
                            }
                        }
                    }

                    filterSection(title: "Tipologia") {
                        Menu {
                            Button {
                                selectedKanjiType = nil
                            } label: {
                                menuLabel(title: String(localized: "Tutte"), isSelected: selectedKanjiType == nil)
                            }

                            ForEach(LibraryKanjiType.allCases) { type in
                                Button {
                                    selectedKanjiType = type
                                } label: {
                                    menuLabel(title: type.localizedTitle, isSelected: selectedKanjiType == type)
                                }
                            }
                        } label: {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(selectedKanjiType?.localizedTitle ?? String(localized: "Tutte"))
                                        .font(KanjiKaiFont.semiBold(16))
                                        .foregroundStyle(Color.primaryBrown)

                                    Text(selectedKanjiType?.localizedSubtitle ?? String(localized: "All types"))
                                        .font(KanjiKaiFont.regular(13))
                                        .foregroundStyle(Color.secondaryBrown)
                                }

                                Spacer()

                                Image(systemName: "chevron.down")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(Color.secondaryBrown)
                            }
                            .padding(12)
                            .background(Color.warmWhite)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.softGray.opacity(0.5), lineWidth: 1)
                            )
                        }
                    }

                    filterSection(title: "Numero di tratti") {
                        HStack(spacing: 10) {
                            TextField("Es. 4", text: $strokeCountText)
                                .font(KanjiKaiFont.regular(16))
                                .keyboardType(.numberPad)
                                .padding(.horizontal, 12)
                                .frame(height: 44)
                                .background(Color.warmWhite)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(Color.softGray.opacity(0.5), lineWidth: 1)
                                )

                            if !strokeCountText.isEmpty {
                                Button {
                                    strokeCountText = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 22, weight: .semibold))
                                        .foregroundStyle(Color.secondaryBrown.opacity(0.65))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(20)
            }
            .background(Color.creamBG.ignoresSafeArea())
            .navigationTitle("Filtri")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Reset", action: onReset)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func filterSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(LocalizedStringKey(title))
                .font(KanjiKaiFont.bold(20, relativeTo: .title3))
                .foregroundStyle(Color.primaryBrown)

            content()
        }
    }

    private func chipGrid<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 78), spacing: 8)], alignment: .leading, spacing: 8) {
            content()
        }
    }

    private func filterButton(_ title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(LocalizedStringKey(title))
                .font(KanjiKaiFont.medium(15))
                .foregroundStyle(isSelected ? Color.warmWhite : Color.primaryBrown)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 9)
                .background(isSelected ? Color.primaryBrown : Color.warmWhite)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.primaryBrown.opacity(isSelected ? 0 : 0.22), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    private func menuLabel(title: String, isSelected: Bool) -> some View {
        Label {
            Text(title)
        } icon: {
            if isSelected {
                Image(systemName: "checkmark")
            }
        }
    }
}

struct KanjiDetailView: View {
    @Environment(LearningProgressStore.self) private var progressStore

    let item: KanjiItem

    private var currentItem: KanjiItem {
        item.withUserState(
            completionDate: progressStore.completionDate(for: item),
            isFavorite: progressStore.isFavorite(item)
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                YukiCard(backgroundColor: currentItem.masteryLevel.color.color.opacity(0.72)) {
                    VStack(spacing: 12) {
                        Text(currentItem.character)
                            .font(.system(size: 112, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.charcoal)

                        Text(currentItem.localizedMeaning)
                            .font(KanjiKaiFont.bold(30, relativeTo: .title))
                            .foregroundStyle(Color.primaryBrown)

                        Text(currentItem.reading)
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
        .navigationTitle(currentItem.localizedMeaning)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    progressStore.toggleFavorite(currentItem)
                } label: {
                    Image(systemName: currentItem.isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(currentItem.isFavorite ? Color.coral : Color.primaryBrown)
                }
                .accessibilityLabel(currentItem.isFavorite ? "Remove from favorites" : "Add to favorites")
            }
        }
    }

    private var detailRows: some View {
        YukiCard(backgroundColor: Color.warmWhite) {
            VStack(spacing: 12) {
                infoRow(title: "Category", value: String(localized: LocalizedStringResource(stringLiteral: currentItem.category)))
                infoRow(title: "Order", value: "#\(currentItem.order)")
                infoRow(title: "Mastery", value: String(localized: LocalizedStringResource(stringLiteral: currentItem.masteryLevel.rawValue)))
                infoRow(title: "Favorite", value: currentItem.isFavorite ? "Yes" : "No")
                infoRow(title: "Completed", value: currentItem.isCompleted ? "Yes" : "No")
            }
        }
    }

    private var exampleWordsText: String {
        guard !currentItem.exampleWords.isEmpty else {
            return "Example words will appear here as this kanji receives study data."
        }

        return currentItem.exampleWords
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
            if currentItem.trainingStrokes.isEmpty && currentItem.kanjiVGFileName == nil {
                Text("Stroke guide coming soon")
                    .font(KanjiKaiFont.semiBold(16))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .foregroundStyle(Color.secondaryBrown)
                    .background(Color.softGray.opacity(0.35))
                    .clipShape(Capsule())
            } else {
                NavigationLink {
                    KanjiTrainingView(kanji: currentItem)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "pencil.and.scribble")
                        Text("Practice \(currentItem.character)")
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
