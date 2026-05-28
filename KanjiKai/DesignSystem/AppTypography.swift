//
//  AppTypography.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 27/05/2026.
//

import CoreText
import SwiftUI

enum KanjiKaiFont {
    private static let fontFileNames = [
        "Baloo2-Regular",
        "Baloo2-Medium",
        "Baloo2-SemiBold",
        "Baloo2-Bold"
    ]

    private static var didRegisterFonts = false

    static func registerFonts() {
        guard !didRegisterFonts else { return }

        for fileName in fontFileNames {
            let fontURL = Bundle.main.url(forResource: fileName, withExtension: "ttf", subdirectory: "Fonts")
                ?? Bundle.main.url(forResource: fileName, withExtension: "ttf")

            guard let fontURL else { continue }
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
        }

        didRegisterFonts = true
    }

    static func regular(_ size: CGFloat, relativeTo textStyle: Font.TextStyle = .body) -> Font {
        Font.custom("Baloo2-Regular", size: size, relativeTo: textStyle)
    }

    static func medium(_ size: CGFloat, relativeTo textStyle: Font.TextStyle = .body) -> Font {
        Font.custom("Baloo2-Medium", size: size, relativeTo: textStyle)
    }

    static func semiBold(_ size: CGFloat, relativeTo textStyle: Font.TextStyle = .body) -> Font {
        Font.custom("Baloo2-SemiBold", size: size, relativeTo: textStyle)
    }

    static func bold(_ size: CGFloat, relativeTo textStyle: Font.TextStyle = .body) -> Font {
        Font.custom("Baloo2-Bold", size: size, relativeTo: textStyle)
    }
}
