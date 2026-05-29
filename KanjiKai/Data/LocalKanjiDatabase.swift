//
//  LocalKanjiDatabase.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 28/05/2026.
//

import CoreGraphics
import Foundation

enum LocalKanjiDatabase {
    static let n5Kanji: [KanjiItem] = [
        oneKanji,
        twoKanji,
        threeKanji,
        fourKanji,
        item(5, "五", "kanji.meaning.005", "ご / いつ"),
        item(6, "六", "kanji.meaning.006", "ろく / むっ"),
        item(7, "七", "kanji.meaning.007", "しち / なな"),
        item(8, "八", "kanji.meaning.008", "はち / やっ, よう"),
        item(9, "九", "kanji.meaning.009", "きゅう, く / ここの"),
        item(10, "十", "kanji.meaning.010", "じゅう / とお"),
        item(11, "百", "kanji.meaning.011", "ひゃく"),
        item(12, "千", "kanji.meaning.012", "せん / ち"),
        item(13, "万", "kanji.meaning.013", "まん, ばん"),
        item(14, "円", "kanji.meaning.014", "えん / まる"),
        sunDayKanji,
        item(16, "月", "kanji.meaning.016", "げつ, がつ / つき"),
        item(17, "火", "kanji.meaning.017", "か / ひ"),
        item(18, "水", "kanji.meaning.018", "すい / みず"),
        item(19, "木", "kanji.meaning.019", "もく, ぼく / き"),
        item(20, "金", "kanji.meaning.020", "きん, こん / かね"),
        item(21, "土", "kanji.meaning.021", "ど, と / つち"),
        item(22, "曜", "kanji.meaning.022", "よう"),
        item(23, "本", "kanji.meaning.023", "ほん / もと"),
        item(24, "人", "kanji.meaning.024", "じん, にん / ひと"),
        item(25, "口", "kanji.meaning.025", "こう, く / くち"),
        item(26, "目", "kanji.meaning.026", "もく / め"),
        item(27, "耳", "kanji.meaning.027", "じ / みみ"),
        item(28, "手", "kanji.meaning.028", "しゅ / て"),
        item(29, "足", "kanji.meaning.029", "そく / あし, た"),
        item(30, "力", "kanji.meaning.030", "りょく, りき / ちから"),
        item(31, "父", "kanji.meaning.031", "ふ / ちち, とう"),
        item(32, "母", "kanji.meaning.032", "ぼ / はは, かあ"),
        item(33, "女", "kanji.meaning.033", "じょ, にょ / おんな"),
        item(34, "男", "kanji.meaning.034", "だん, なん / おとこ"),
        item(35, "子", "kanji.meaning.035", "し, す / こ"),
        item(36, "友", "kanji.meaning.036", "ゆう / とも"),
        item(37, "上", "kanji.meaning.037", "じょう / うえ, あ"),
        item(38, "下", "kanji.meaning.038", "か, げ / した, さ, くだ"),
        item(39, "左", "kanji.meaning.039", "さ / ひだり"),
        item(40, "右", "kanji.meaning.040", "う, ゆう / みぎ"),
        item(41, "中", "kanji.meaning.041", "ちゅう / なか"),
        item(42, "大", "kanji.meaning.042", "だい, たい / おお"),
        item(43, "小", "kanji.meaning.043", "しょう / ちい, こ, お"),
        item(44, "少", "kanji.meaning.044", "しょう / すこ, すく"),
        item(45, "山", "kanji.meaning.045", "さん / やま"),
        item(46, "川", "kanji.meaning.046", "せん / かわ"),
        item(47, "田", "kanji.meaning.047", "でん / た"),
        item(48, "天", "kanji.meaning.048", "てん / あめ, あま"),
        item(49, "気", "kanji.meaning.049", "き, け"),
        item(50, "雨", "kanji.meaning.050", "う / あめ, あま"),
        item(51, "空", "kanji.meaning.051", "くう / そら, あ, から"),
        item(52, "花", "kanji.meaning.052", "か / はな"),
        item(53, "学", "kanji.meaning.053", "がく / まな"),
        item(54, "生", "kanji.meaning.054", "せい, しょう / い, う, なま"),
        item(55, "校", "kanji.meaning.055", "こう"),
        item(56, "先", "kanji.meaning.056", "せん / さき"),
        item(57, "何", "kanji.meaning.057", "か / なに, なん"),
        item(58, "時", "kanji.meaning.058", "じ / とき"),
        item(59, "分", "kanji.meaning.059", "ぶん, ふん, ぶ / わ"),
        item(60, "半", "kanji.meaning.060", "はん / なか"),
        item(61, "毎", "kanji.meaning.061", "まい / ごと"),
        item(62, "今", "kanji.meaning.062", "こん, きん / いま"),
        item(63, "年", "kanji.meaning.063", "ねん / とし"),
        item(64, "間", "kanji.meaning.064", "かん, けん / あいだ, ま"),
        item(65, "前", "kanji.meaning.065", "ぜん / まえ"),
        item(66, "後", "kanji.meaning.066", "ご, こう / あと, うし, のち"),
        item(67, "午", "kanji.meaning.067", "ご"),
        item(68, "朝", "kanji.meaning.068", "ちょう / あさ"),
        item(69, "昼", "kanji.meaning.069", "ちゅう / ひる"),
        item(70, "晩", "kanji.meaning.070", "ばん"),
        item(71, "夜", "kanji.meaning.071", "や / よる, よ"),
        item(72, "週", "kanji.meaning.072", "しゅう"),
        item(73, "東", "kanji.meaning.073", "とう / ひがし"),
        item(74, "西", "kanji.meaning.074", "せい, さい / にし"),
        item(75, "南", "kanji.meaning.075", "なん, な / みなみ"),
        item(76, "北", "kanji.meaning.076", "ほく / きた"),
        item(77, "外", "kanji.meaning.077", "がい, げ / そと, ほか"),
        item(78, "名", "kanji.meaning.078", "めい, みょう / な"),
        item(79, "高", "kanji.meaning.079", "こう / たか"),
        item(80, "安", "kanji.meaning.080", "あん / やす"),
        item(81, "新", "kanji.meaning.081", "しん / あたら, あら, にい"),
        item(82, "古", "kanji.meaning.082", "こ / ふる"),
        item(83, "長", "kanji.meaning.083", "ちょう / なが"),
        item(84, "多", "kanji.meaning.084", "た / おお"),
        item(85, "行", "kanji.meaning.085", "こう, ぎょう / い, ゆ, おこな"),
        item(86, "来", "kanji.meaning.086", "らい / く, き, こ"),
        item(87, "帰", "kanji.meaning.087", "き / かえ"),
        item(88, "食", "kanji.meaning.088", "しょく, じき / た"),
        item(89, "飲", "kanji.meaning.089", "いん / の"),
        item(90, "見", "kanji.meaning.090", "けん / み"),
        item(91, "聞", "kanji.meaning.091", "ぶん, もん / き"),
        item(92, "読", "kanji.meaning.092", "どく, とく / よ"),
        item(93, "書", "kanji.meaning.093", "しょ / か"),
        item(94, "話", "kanji.meaning.094", "わ / はな, はなし"),
        item(95, "買", "kanji.meaning.095", "ばい / か"),
        item(96, "出", "kanji.meaning.096", "しゅつ, すい / で, だ"),
        item(97, "入", "kanji.meaning.097", "にゅう / はい, い"),
        item(98, "休", "kanji.meaning.098", "きゅう / やす"),
        item(99, "会", "kanji.meaning.099", "かい, え / あ"),
        item(100, "社", "kanji.meaning.100", "しゃ / やしろ"),
        item(101, "店", "kanji.meaning.101", "てん / みせ"),
        item(102, "駅", "kanji.meaning.102", "えき"),
        item(103, "道", "kanji.meaning.103", "どう, とう / みち"),
        item(104, "車", "kanji.meaning.104", "しゃ / くるま"),
        item(105, "電", "kanji.meaning.105", "でん"),
        item(106, "語", "kanji.meaning.106", "ご / かた"),
        item(107, "国", "kanji.meaning.107", "こく / くに"),
        item(108, "白", "kanji.meaning.108", "はく, びゃく / しろ, しら"),
        item(109, "赤", "kanji.meaning.109", "せき / あか"),
        item(110, "青", "kanji.meaning.110", "せい, しょう / あお")
    ]

    static func kanji(character: String) -> KanjiItem? {
        n5Kanji.first { $0.character == character }
    }

    static func kanji(order: Int) -> KanjiItem? {
        n5Kanji.first { $0.order == order }
    }

    private static var oneKanji: KanjiItem {
        KanjiItem(
            order: 1,
            character: "一",
            meaning: "kanji.meaning.001",
            reading: "いち, いつ / ひと",
            category: "N5",
            masteryLevel: .apprentice,
            isFavorite: false,
            kanjiVGFileName: "04e00",
            trainingStrokes: [
                KanjiStroke(id: 1, strokeType: .horizontal, startPoint: CGPoint(x: 0.25, y: 0.50), endPoint: CGPoint(x: 0.75, y: 0.46), cornerPoint: nil, direction: .leftToRight)
            ],
            exampleWords: [
                KanjiExampleWord(word: "一人", meaning: "example.meaning.ichinin"),
                KanjiExampleWord(word: "一日", meaning: "example.meaning.ichinichi"),
                KanjiExampleWord(word: "一月", meaning: "example.meaning.ichigatsu")
            ]
        )
    }

    private static var twoKanji: KanjiItem {
        KanjiItem(
            order: 2,
            character: "二",
            meaning: "kanji.meaning.002",
            reading: "に, じ / ふた",
            category: "N5",
            masteryLevel: .apprentice,
            isFavorite: false,
            kanjiVGFileName: "04e8c",
            trainingStrokes: [
                KanjiStroke(id: 1, strokeType: .horizontal, startPoint: CGPoint(x: 0.36, y: 0.34), endPoint: CGPoint(x: 0.66, y: 0.30), cornerPoint: nil, direction: .leftToRight),
                KanjiStroke(id: 2, strokeType: .horizontal, startPoint: CGPoint(x: 0.18, y: 0.68), endPoint: CGPoint(x: 0.84, y: 0.62), cornerPoint: nil, direction: .leftToRight)
            ],
            exampleWords: [
                KanjiExampleWord(word: "二月", meaning: "example.meaning.nigatsu"),
                KanjiExampleWord(word: "二人", meaning: "example.meaning.futari"),
                KanjiExampleWord(word: "二日", meaning: "example.meaning.futsuka")
            ]
        )
    }

    private static var threeKanji: KanjiItem {
        KanjiItem(
            order: 3,
            character: "三",
            meaning: "kanji.meaning.003",
            reading: "さん / みっ",
            category: "N5",
            masteryLevel: .apprentice,
            isFavorite: false,
            kanjiVGFileName: "04e09",
            trainingStrokes: [
                KanjiStroke(id: 1, strokeType: .horizontal, startPoint: CGPoint(x: 0.30, y: 0.24), endPoint: CGPoint(x: 0.70, y: 0.18), cornerPoint: nil, direction: .leftToRight),
                KanjiStroke(id: 2, strokeType: .horizontal, startPoint: CGPoint(x: 0.34, y: 0.50), endPoint: CGPoint(x: 0.66, y: 0.46), cornerPoint: nil, direction: .leftToRight),
                KanjiStroke(id: 3, strokeType: .horizontal, startPoint: CGPoint(x: 0.16, y: 0.78), endPoint: CGPoint(x: 0.84, y: 0.72), cornerPoint: nil, direction: .leftToRight)
            ],
            exampleWords: [
                KanjiExampleWord(word: "三月", meaning: "example.meaning.sangatsu"),
                KanjiExampleWord(word: "三日", meaning: "example.meaning.mikka"),
                KanjiExampleWord(word: "三人", meaning: "example.meaning.sannin")
            ]
        )
    }

    private static var fourKanji: KanjiItem {
        KanjiItem(
            order: 4,
            character: "四",
            meaning: "kanji.meaning.004",
            reading: "し / よん, よ",
            category: "N5",
            masteryLevel: .apprentice,
            isFavorite: false,
            kanjiVGFileName: "056db",
            trainingStrokes: [
                KanjiStroke(
                    id: 1,
                    strokeType: .vertical,
                    startPoint: CGPoint(x: 0.22, y: 0.24),
                    endPoint: CGPoint(x: 0.25, y: 0.83),
                    cornerPoint: nil,
                    direction: .topToBottom,
                    guideCommands: [
                        .move(to: CGPoint(x: 0.22, y: 0.24)),
                        .quadCurve(to: CGPoint(x: 0.24, y: 0.55), control: CGPoint(x: 0.25, y: 0.39)),
                        .quadCurve(to: CGPoint(x: 0.25, y: 0.83), control: CGPoint(x: 0.23, y: 0.71))
                    ]
                ),
                KanjiStroke(
                    id: 2,
                    strokeType: .corner,
                    startPoint: CGPoint(x: 0.24, y: 0.25),
                    endPoint: CGPoint(x: 0.79, y: 0.83),
                    cornerPoint: CGPoint(x: 0.79, y: 0.25),
                    direction: .rightThenDown,
                    guideCommands: [
                        .move(to: CGPoint(x: 0.24, y: 0.25)),
                        .quadCurve(to: CGPoint(x: 0.52, y: 0.23), control: CGPoint(x: 0.38, y: 0.25)),
                        .quadCurve(to: CGPoint(x: 0.79, y: 0.25), control: CGPoint(x: 0.67, y: 0.20)),
                        .quadCurve(to: CGPoint(x: 0.78, y: 0.56), control: CGPoint(x: 0.83, y: 0.34)),
                        .quadCurve(to: CGPoint(x: 0.79, y: 0.83), control: CGPoint(x: 0.76, y: 0.73))
                    ]
                ),
                KanjiStroke(
                    id: 3,
                    strokeType: .vertical,
                    startPoint: CGPoint(x: 0.43, y: 0.29),
                    endPoint: CGPoint(x: 0.34, y: 0.56),
                    cornerPoint: nil,
                    direction: .topToBottom,
                    guideCommands: [
                        .move(to: CGPoint(x: 0.43, y: 0.29)),
                        .quadCurve(to: CGPoint(x: 0.40, y: 0.45), control: CGPoint(x: 0.44, y: 0.37)),
                        .quadCurve(to: CGPoint(x: 0.34, y: 0.56), control: CGPoint(x: 0.37, y: 0.53))
                    ]
                ),
                KanjiStroke(
                    id: 4,
                    strokeType: .corner,
                    startPoint: CGPoint(x: 0.59, y: 0.28),
                    endPoint: CGPoint(x: 0.69, y: 0.50),
                    cornerPoint: CGPoint(x: 0.59, y: 0.49),
                    direction: .downThenRight,
                    guideCommands: [
                        .move(to: CGPoint(x: 0.59, y: 0.28)),
                        .quadCurve(to: CGPoint(x: 0.59, y: 0.49), control: CGPoint(x: 0.56, y: 0.40)),
                        .quadCurve(to: CGPoint(x: 0.69, y: 0.50), control: CGPoint(x: 0.62, y: 0.54))
                    ]
                ),
                KanjiStroke(
                    id: 5,
                    strokeType: .horizontal,
                    startPoint: CGPoint(x: 0.25, y: 0.75),
                    endPoint: CGPoint(x: 0.67, y: 0.70),
                    cornerPoint: nil,
                    direction: .leftToRight,
                    guideCommands: [
                        .move(to: CGPoint(x: 0.25, y: 0.75)),
                        .quadCurve(to: CGPoint(x: 0.48, y: 0.72), control: CGPoint(x: 0.36, y: 0.74)),
                        .quadCurve(to: CGPoint(x: 0.67, y: 0.70), control: CGPoint(x: 0.58, y: 0.69))
                    ]
                )
            ],
            exampleWords: [
                KanjiExampleWord(word: "四月", meaning: "example.meaning.shigatsu"),
                KanjiExampleWord(word: "四日", meaning: "example.meaning.yokka"),
                KanjiExampleWord(word: "四人", meaning: "example.meaning.yonin")
            ]
        )
    }

    private static var sunDayKanji: KanjiItem {
        KanjiItem(
            order: 15,
            character: "日",
            meaning: "kanji.meaning.015",
            reading: "にち, じつ / ひ, か",
            category: "N5",
            masteryLevel: .apprentice,
            isFavorite: false,
            kanjiVGFileName: "065e5",
            trainingStrokes: [
                KanjiStroke(id: 1, strokeType: .vertical, startPoint: CGPoint(x: 0.30, y: 0.20), endPoint: CGPoint(x: 0.30, y: 0.80), cornerPoint: nil, direction: .topToBottom),
                KanjiStroke(id: 2, strokeType: .corner, startPoint: CGPoint(x: 0.30, y: 0.20), endPoint: CGPoint(x: 0.70, y: 0.80), cornerPoint: CGPoint(x: 0.70, y: 0.20), direction: .rightThenDown),
                KanjiStroke(id: 3, strokeType: .horizontal, startPoint: CGPoint(x: 0.30, y: 0.50), endPoint: CGPoint(x: 0.70, y: 0.50), cornerPoint: nil, direction: .leftToRight),
                KanjiStroke(id: 4, strokeType: .horizontal, startPoint: CGPoint(x: 0.30, y: 0.80), endPoint: CGPoint(x: 0.70, y: 0.80), cornerPoint: nil, direction: .leftToRight)
            ],
            exampleWords: [
                KanjiExampleWord(word: "日本", meaning: "example.meaning.nihon"),
                KanjiExampleWord(word: "日曜日", meaning: "example.meaning.nichiyoubi"),
                KanjiExampleWord(word: "今日", meaning: "example.meaning.kyou")
            ]
        )
    }

    private static func item(
        _ order: Int,
        _ character: String,
        _ meaning: String,
        _ reading: String,
        favorite: Bool = false,
        completed: Bool = false,
        completionDate: Date? = nil
    ) -> KanjiItem {
        KanjiItem(
            order: order,
            character: character,
            meaning: meaning,
            reading: reading,
            category: "N5",
            masteryLevel: completed ? .adept : .apprentice,
            isFavorite: favorite,
            isCompleted: completed,
            completionDate: completionDate,
            kanjiVGFileName: kanjiVGFileName(for: character)
        )
    }

    private static func kanjiVGFileName(for character: String) -> String? {
        guard let scalar = character.unicodeScalars.first else { return nil }
        return String(format: "%05x", scalar.value)
    }
}
