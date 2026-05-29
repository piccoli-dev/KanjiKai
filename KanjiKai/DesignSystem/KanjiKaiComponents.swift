//
//  KanjiKaiComponents.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 27/05/2026.
//

import SwiftUI

struct YukiCard<Content: View>: View {
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let content: Content

    init(
        backgroundColor: Color = .creamCard,
        cornerRadius: CGFloat = 24,
        @ViewBuilder content: () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    var body: some View {
        content
            .padding(18)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: Color.primaryBrown.opacity(0.08), radius: 12, x: 0, y: 6)
    }
}

struct PrimaryButton: View {
    let title: String
    let icon: String?
    let backgroundColor: Color
    let foregroundColor: Color
    let action: () -> Void

    init(
        _ title: String,
        icon: String? = nil,
        backgroundColor: Color = .primaryBrown,
        foregroundColor: Color = .warmWhite,
        action: @escaping () -> Void = {}
    ) {
        self.title = title
        self.icon = icon
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                }

                Text(title)
                    .font(KanjiKaiFont.semiBold(17))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .foregroundStyle(foregroundColor)
            .background(backgroundColor)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct SectionHeader: View {
    let title: String
    let actionTitle: String?

    init(_ title: String, actionTitle: String? = nil) {
        self.title = title
        self.actionTitle = actionTitle
    }

    var body: some View {
        HStack {
            Text(title)
                .font(KanjiKaiFont.bold(24, relativeTo: .title2))
                .foregroundStyle(Color.primaryBrown)

            Spacer()

            if let actionTitle {
                Text(actionTitle)
                    .font(KanjiKaiFont.medium(14))
                    .foregroundStyle(Color.secondaryBrown.opacity(0.75))
            }
        }
    }
}

struct KanjiCard: View {
    let item: KanjiItem

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Spacer()

                if item.isFavorite {
                    Image(systemName: "heart.fill")
                        .font(.caption)
                        .foregroundStyle(Color.coral)
                }
            }
            .frame(height: 12)

            Text(item.character)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundStyle(Color.charcoal)

            Text(item.localizedMeaning)
                .font(KanjiKaiFont.medium(15))
                .foregroundStyle(Color.primaryBrown)
                .lineLimit(1)

            Text(LocalizedStringKey(item.masteryLevel.rawValue))
                .font(KanjiKaiFont.medium(12))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(item.masteryLevel.color.color.opacity(0.75))
                .foregroundStyle(Color.primaryBrown)
                .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding(14)
        .background(Color.warmWhite)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(item.masteryLevel.color.color.opacity(0.55), lineWidth: 2)
        )
    }
}

struct TrainingTaskCard: View {
    let task: TrainingTask

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: task.icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(Color.primaryBrown)
                .frame(width: 52, height: 52)
                .background(task.accentColor.color)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey(task.title))
                    .font(KanjiKaiFont.semiBold(18))
                    .foregroundStyle(Color.primaryBrown)

                Text(LocalizedStringKey(task.subtitle))
                    .font(KanjiKaiFont.regular(14))
                    .foregroundStyle(Color.secondaryBrown.opacity(0.78))
                    .lineLimit(2)
            }

            Spacer()

            Text("\(task.count)")
                .font(KanjiKaiFont.bold(15))
                .foregroundStyle(Color.primaryBrown)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(task.accentColor.color.opacity(0.65))
                .clipShape(Capsule())
        }
        .padding(16)
        .background(Color.warmWhite)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

struct ProgressStatCard: View {
    let stat: ProgressStat
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedStringKey(stat.title))
                .font(KanjiKaiFont.medium(14))
                .foregroundStyle(Color.secondaryBrown)

            Text(stat.value)
                .font(KanjiKaiFont.bold(30, relativeTo: .title))
                .foregroundStyle(Color.primaryBrown)

            Text(LocalizedStringKey(stat.subtitle))
                .font(KanjiKaiFont.regular(13))
                .foregroundStyle(Color.secondaryBrown.opacity(0.75))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(accentColor.opacity(0.72))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(KanjiKaiFont.medium(14))
                .foregroundStyle(isSelected ? Color.primaryBrown : Color.secondaryBrown)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? color : Color.warmWhite)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.primaryBrown.opacity(0.45) : Color.softGray.opacity(0.55), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}
