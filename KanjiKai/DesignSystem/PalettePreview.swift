//
//  PalettePreview.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 26/05/2026.
//

import SwiftUI

struct PalettePreview: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("KanjiKai")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(Color.charcoal)

                    Text("Palette")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(Color.primaryBrown)
                }

                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 150), spacing: 16)],
                    spacing: 16
                ) {
                    ForEach(AppColor.allCases) { item in
                        PaletteSwatch(item: item)
                    }
                }
            }
            .padding(24)
        }
        .background(Color.creamBG)
    }
}

private struct PaletteSwatch: View {
    let item: AppColor

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(item.color)
                .frame(height: 92)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.softGray.opacity(0.55), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .foregroundStyle(Color.charcoal)

                Text(item.hex)
                    .font(.caption.monospaced())
                    .foregroundStyle(Color.secondaryBrown)
            }
        }
        .padding(12)
        .background(Color.creamCard)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    PalettePreview()
}
