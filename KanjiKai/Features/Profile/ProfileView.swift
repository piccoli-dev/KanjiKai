//
//  ProfileView.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 27/05/2026.
//

import SwiftUI

struct ProfileView: View {
    private let stats = [
        ProgressStat(title: "Total kanji learned", value: "45", subtitle: "of 100"),
        ProgressStat(title: "Current streak", value: "16", subtitle: "days"),
        ProgressStat(title: "Review accuracy", value: "92%", subtitle: "this week")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                profileHeader

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {
                    ForEach(Array(stats.enumerated()), id: \.element.id) { index, stat in
                        ProgressStatCard(stat: stat, accentColor: statAccent(for: index))
                    }
                }

                settingsCard

                Button(role: .destructive) {} label: {
                    Text("Log out")
                        .font(KanjiKaiFont.semiBold(17))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .foregroundStyle(Color.primaryBrown)
                        .background(Color.warmWhite)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color.primaryBrown.opacity(0.35), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(20)
        }
        .background(Color.creamBG.ignoresSafeArea())
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var profileHeader: some View {
        YukiCard(backgroundColor: Color.apricot.opacity(0.75)) {
            VStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.warmWhite)
                        .frame(width: 104, height: 104)

                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(Color.sage, Color.primaryBrown.opacity(0.22))
                }

                VStack(spacing: 4) {
                    Text("Kristin")
                        .font(KanjiKaiFont.bold(30, relativeTo: .title))
                        .foregroundStyle(Color.primaryBrown)

                    Text("kristin@example.com")
                        .font(KanjiKaiFont.regular(16))
                        .foregroundStyle(Color.secondaryBrown)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var settingsCard: some View {
        YukiCard(backgroundColor: Color.warmWhite) {
            VStack(spacing: 0) {
                settingsRow(title: "Native language", value: "English", icon: "globe")
                Divider().background(Color.softGray)
                settingsRow(title: "Daily goal", value: "20 cards", icon: "target")
                Divider().background(Color.softGray)
                settingsRow(title: "Notifications", value: "On", icon: "bell.fill")
                Divider().background(Color.softGray)
                settingsRow(title: "Appearance", value: "Soft", icon: "paintpalette.fill")
            }
        }
    }

    private func settingsRow(title: String, value: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.primaryBrown)
                .frame(width: 36, height: 36)
                .background(Color.creamCard)
                .clipShape(Circle())

            Text(title)
                .font(KanjiKaiFont.medium(16))
                .foregroundStyle(Color.primaryBrown)

            Spacer()

            Text(value)
                .font(KanjiKaiFont.regular(15))
                .foregroundStyle(Color.secondaryBrown)

            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.softGray)
        }
        .padding(.vertical, 12)
    }

    private func statAccent(for index: Int) -> Color {
        [Color.sky, Color.sage, Color.coral][index % 3]
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
