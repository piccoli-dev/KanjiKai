//
//  KanjiKaiRootView.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 27/05/2026.
//

import SwiftUI

struct KanjiKaiRootView: View {
    @State private var progressStore = LearningProgressStore()

    init() {
        KanjiKaiFont.registerFonts()
    }

    var body: some View {
        TabView {
            NavigationStack {
                TodayView()
            }
            .tabItem {
                Label("Today", systemImage: "house.fill")
            }

            NavigationStack {
                TrainingView()
            }
            .tabItem {
                Label("Training", systemImage: "flame.fill")
            }

            NavigationStack {
                LibraryView()
            }
            .tabItem {
                Label("Library", systemImage: "books.vertical.fill")
            }

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle.fill")
            }
        }
        .tint(Color.primaryBrown)
        .environment(progressStore)
    }
}

#Preview {
    KanjiKaiRootView()
}
