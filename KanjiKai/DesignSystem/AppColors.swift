//
//  AppColors.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 26/05/2026.
//

import SwiftUI

enum AppColor: String, CaseIterable, Identifiable {
    case creamBG
    case creamCard
    case primaryBrown
    case secondaryBrown
    case apricot
    case sage
    case mint
    case sky
    case fujiBlue
    case coral
    case terracotta
    case warmWhite
    case softGray
    case charcoal

    var id: Self { self }

    var name: String {
        switch self {
        case .creamBG:
            "Cream BG"
        case .creamCard:
            "Cream Card"
        case .primaryBrown:
            "Primary Brown"
        case .secondaryBrown:
            "Secondary Brown"
        case .apricot:
            "Apricot"
        case .sage:
            "Sage"
        case .mint:
            "Mint"
        case .sky:
            "Sky"
        case .fujiBlue:
            "Fuji Blue"
        case .coral:
            "Coral"
        case .terracotta:
            "Terracotta"
        case .warmWhite:
            "White"
        case .softGray:
            "Soft Gray"
        case .charcoal:
            "Charcoal"
        }
    }

    var color: Color {
        switch self {
        case .creamBG:
            .creamBG
        case .creamCard:
            .creamCard
        case .primaryBrown:
            .primaryBrown
        case .secondaryBrown:
            .secondaryBrown
        case .apricot:
            .apricot
        case .sage:
            .sage
        case .mint:
            .mint
        case .sky:
            .sky
        case .fujiBlue:
            .fujiBlue
        case .coral:
            .coral
        case .terracotta:
            .terracotta
        case .warmWhite:
            .warmWhite
        case .softGray:
            .softGray
        case .charcoal:
            .charcoal
        }
    }

    var hex: String {
        switch self {
        case .creamBG:
            "#FCF3E8"
        case .creamCard:
            "#F8EEE4"
        case .primaryBrown:
            "#4F4845"
        case .secondaryBrown:
            "#5D4941"
        case .apricot:
            "#FAE2C0"
        case .sage:
            "#D7D0B4"
        case .mint:
            "#ACD3BD"
        case .sky:
            "#C7E5FA"
        case .fujiBlue:
            "#5C9ACC"
        case .coral:
            "#F4B9A5"
        case .terracotta:
            "#DD9C78"
        case .warmWhite:
            "#FEFDFC"
        case .softGray:
            "#CECBC2"
        case .charcoal:
            "#242323"
        }
    }
}

extension Color {
    static let creamBG = Color(red: 252 / 255, green: 243 / 255, blue: 232 / 255)
    static let creamCard = Color(red: 248 / 255, green: 238 / 255, blue: 228 / 255)
    static let primaryBrown = Color(red: 79 / 255, green: 72 / 255, blue: 69 / 255)
    static let secondaryBrown = Color(red: 93 / 255, green: 73 / 255, blue: 65 / 255)

    static let apricot = Color(red: 250 / 255, green: 226 / 255, blue: 192 / 255)
    static let sage = Color(red: 215 / 255, green: 208 / 255, blue: 180 / 255)
    static let mint = Color(red: 172 / 255, green: 211 / 255, blue: 189 / 255)
    static let sky = Color(red: 199 / 255, green: 229 / 255, blue: 250 / 255)
    static let fujiBlue = Color(red: 92 / 255, green: 154 / 255, blue: 204 / 255)
    static let coral = Color(red: 244 / 255, green: 185 / 255, blue: 165 / 255)
    static let terracotta = Color(red: 221 / 255, green: 156 / 255, blue: 120 / 255)

    static let warmWhite = Color(red: 254 / 255, green: 253 / 255, blue: 252 / 255)
    static let softGray = Color(red: 206 / 255, green: 203 / 255, blue: 194 / 255)
    static let charcoal = Color(red: 36 / 255, green: 35 / 255, blue: 35 / 255)
}
