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
        item(5, "五", "cinque", "ご / いつ"),
        item(6, "六", "sei", "ろく / むっ"),
        item(7, "七", "sette", "しち / なな"),
        item(8, "八", "otto", "はち / やっ, よう"),
        item(9, "九", "nove", "きゅう, く / ここの"),
        item(10, "十", "dieci", "じゅう / とお"),
        item(11, "百", "cento", "ひゃく"),
        item(12, "千", "mille", "せん / ち"),
        item(13, "万", "diecimila", "まん, ばん"),
        item(14, "円", "yen, cerchio", "えん / まる"),
        sunDayKanji,
        item(16, "月", "mese, luna", "げつ, がつ / つき"),
        item(17, "火", "fuoco", "か / ひ"),
        item(18, "水", "acqua", "すい / みず"),
        item(19, "木", "albero, legno", "もく, ぼく / き"),
        item(20, "金", "oro, denaro", "きん, こん / かね"),
        item(21, "土", "terra, suolo", "ど, と / つち"),
        item(22, "曜", "giorno della settimana", "よう"),
        item(23, "本", "libro, origine", "ほん / もと"),
        item(24, "人", "persona", "じん, にん / ひと"),
        item(25, "口", "bocca", "こう, く / くち"),
        item(26, "目", "occhio", "もく / め"),
        item(27, "耳", "orecchio", "じ / みみ"),
        item(28, "手", "mano", "しゅ / て"),
        item(29, "足", "piede, gamba", "そく / あし, た"),
        item(30, "力", "forza", "りょく, りき / ちから"),
        item(31, "父", "padre", "ふ / ちち, とう"),
        item(32, "母", "madre", "ぼ / はは, かあ"),
        item(33, "女", "donna", "じょ, にょ / おんな"),
        item(34, "男", "uomo", "だん, なん / おとこ"),
        item(35, "子", "bambino, figlio", "し, す / こ"),
        item(36, "友", "amico", "ゆう / とも"),
        item(37, "上", "sopra, salire", "じょう / うえ, あ"),
        item(38, "下", "sotto, scendere", "か, げ / した, さ, くだ"),
        item(39, "左", "sinistra", "さ / ひだり"),
        item(40, "右", "destra", "う, ゆう / みぎ"),
        item(41, "中", "dentro, centro", "ちゅう / なか"),
        item(42, "大", "grande", "だい, たい / おお"),
        item(43, "小", "piccolo", "しょう / ちい, こ, お"),
        item(44, "少", "poco, pochi", "しょう / すこ, すく"),
        item(45, "山", "montagna", "さん / やま"),
        item(46, "川", "fiume", "せん / かわ"),
        item(47, "田", "risaia, campo", "でん / た"),
        item(48, "天", "cielo", "てん / あめ, あま"),
        item(49, "気", "spirito, aria, energia", "き, け"),
        item(50, "雨", "pioggia", "う / あめ, あま"),
        item(51, "空", "cielo, vuoto", "くう / そら, あ, から"),
        item(52, "花", "fiore", "か / はな"),
        item(53, "学", "studio, imparare", "がく / まな"),
        item(54, "生", "vita, nascere, studente", "せい, しょう / い, う, なま"),
        item(55, "校", "scuola", "こう"),
        item(56, "先", "prima, precedente", "せん / さき"),
        item(57, "何", "cosa, che cosa", "か / なに, なん"),
        item(58, "時", "tempo, ora", "じ / とき"),
        item(59, "分", "minuto, parte, capire", "ぶん, ふん, ぶ / わ"),
        item(60, "半", "metà", "はん / なか"),
        item(61, "毎", "ogni", "まい / ごと"),
        item(62, "今", "adesso", "こん, きん / いま"),
        item(63, "年", "anno", "ねん / とし"),
        item(64, "間", "intervallo, tra", "かん, けん / あいだ, ま"),
        item(65, "前", "davanti, prima", "ぜん / まえ"),
        item(66, "後", "dopo, dietro", "ご, こう / あと, うし, のち"),
        item(67, "午", "mezzogiorno", "ご"),
        item(68, "朝", "mattina", "ちょう / あさ"),
        item(69, "昼", "mezzogiorno, giorno", "ちゅう / ひる"),
        item(70, "晩", "sera", "ばん"),
        item(71, "夜", "notte", "や / よる, よ"),
        item(72, "週", "settimana", "しゅう"),
        item(73, "東", "est", "とう / ひがし"),
        item(74, "西", "ovest", "せい, さい / にし"),
        item(75, "南", "sud", "なん, な / みなみ"),
        item(76, "北", "nord", "ほく / きた"),
        item(77, "外", "fuori, altro", "がい, げ / そと, ほか"),
        item(78, "名", "nome", "めい, みょう / な"),
        item(79, "高", "alto, caro", "こう / たか"),
        item(80, "安", "economico, sicuro, tranquillo", "あん / やす"),
        item(81, "新", "nuovo", "しん / あたら, あら, にい"),
        item(82, "古", "vecchio, antico", "こ / ふる"),
        item(83, "長", "lungo, capo", "ちょう / なが"),
        item(84, "多", "molti", "た / おお"),
        item(85, "行", "andare, condurre", "こう, ぎょう / い, ゆ, おこな"),
        item(86, "来", "venire", "らい / く, き, こ"),
        item(87, "帰", "tornare", "き / かえ"),
        item(88, "食", "mangiare", "しょく, じき / た"),
        item(89, "飲", "bere", "いん / の"),
        item(90, "見", "vedere", "けん / み"),
        item(91, "聞", "ascoltare, chiedere", "ぶん, もん / き"),
        item(92, "読", "leggere", "どく, とく / よ"),
        item(93, "書", "scrivere", "しょ / か"),
        item(94, "話", "parlare, discorso", "わ / はな, はなし"),
        item(95, "買", "comprare", "ばい / か"),
        item(96, "出", "uscire, tirare fuori", "しゅつ, すい / で, だ"),
        item(97, "入", "entrare, inserire", "にゅう / はい, い"),
        item(98, "休", "riposare", "きゅう / やす"),
        item(99, "会", "incontrare, riunione", "かい, え / あ"),
        item(100, "社", "azienda, santuario", "しゃ / やしろ"),
        item(101, "店", "negozio", "てん / みせ"),
        item(102, "駅", "stazione", "えき"),
        item(103, "道", "strada, via", "どう, とう / みち"),
        item(104, "車", "macchina, veicolo", "しゃ / くるま"),
        item(105, "電", "elettricità", "でん"),
        item(106, "語", "lingua, parola", "ご / かた"),
        item(107, "国", "paese, nazione", "こく / くに"),
        item(108, "白", "bianco", "はく, びゃく / しろ, しら"),
        item(109, "赤", "rosso", "せき / あか"),
        item(110, "青", "blu, verde", "せい, しょう / あお")
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
            meaning: "uno",
            reading: "いち, いつ / ひと",
            category: "N5",
            masteryLevel: .apprentice,
            isFavorite: false,
            trainingStrokes: [
                KanjiStroke(id: 1, strokeType: .horizontal, startPoint: CGPoint(x: 0.25, y: 0.50), endPoint: CGPoint(x: 0.75, y: 0.46), cornerPoint: nil, direction: .leftToRight)
            ],
            exampleWords: [
                KanjiExampleWord(word: "一人", meaning: "una persona"),
                KanjiExampleWord(word: "一日", meaning: "un giorno"),
                KanjiExampleWord(word: "一月", meaning: "gennaio")
            ]
        )
    }

    private static var twoKanji: KanjiItem {
        KanjiItem(
            order: 2,
            character: "二",
            meaning: "due",
            reading: "に, じ / ふた",
            category: "N5",
            masteryLevel: .apprentice,
            isFavorite: false,
            trainingStrokes: [
                KanjiStroke(id: 1, strokeType: .horizontal, startPoint: CGPoint(x: 0.36, y: 0.34), endPoint: CGPoint(x: 0.66, y: 0.30), cornerPoint: nil, direction: .leftToRight),
                KanjiStroke(id: 2, strokeType: .horizontal, startPoint: CGPoint(x: 0.18, y: 0.68), endPoint: CGPoint(x: 0.84, y: 0.62), cornerPoint: nil, direction: .leftToRight)
            ],
            exampleWords: [
                KanjiExampleWord(word: "二月", meaning: "febbraio"),
                KanjiExampleWord(word: "二人", meaning: "due persone"),
                KanjiExampleWord(word: "二日", meaning: "due giorni")
            ]
        )
    }

    private static var threeKanji: KanjiItem {
        KanjiItem(
            order: 3,
            character: "三",
            meaning: "tre",
            reading: "さん / みっ",
            category: "N5",
            masteryLevel: .apprentice,
            isFavorite: false,
            trainingStrokes: [
                KanjiStroke(id: 1, strokeType: .horizontal, startPoint: CGPoint(x: 0.30, y: 0.24), endPoint: CGPoint(x: 0.70, y: 0.18), cornerPoint: nil, direction: .leftToRight),
                KanjiStroke(id: 2, strokeType: .horizontal, startPoint: CGPoint(x: 0.34, y: 0.50), endPoint: CGPoint(x: 0.66, y: 0.46), cornerPoint: nil, direction: .leftToRight),
                KanjiStroke(id: 3, strokeType: .horizontal, startPoint: CGPoint(x: 0.16, y: 0.78), endPoint: CGPoint(x: 0.84, y: 0.72), cornerPoint: nil, direction: .leftToRight)
            ],
            exampleWords: [
                KanjiExampleWord(word: "三月", meaning: "marzo"),
                KanjiExampleWord(word: "三日", meaning: "tre giorni"),
                KanjiExampleWord(word: "三人", meaning: "tre persone")
            ]
        )
    }

    private static var fourKanji: KanjiItem {
        KanjiItem(
            order: 4,
            character: "四",
            meaning: "quattro",
            reading: "し / よん, よ",
            category: "N5",
            masteryLevel: .apprentice,
            isFavorite: false,
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
                KanjiExampleWord(word: "四月", meaning: "aprile"),
                KanjiExampleWord(word: "四日", meaning: "quattro giorni"),
                KanjiExampleWord(word: "四人", meaning: "quattro persone")
            ]
        )
    }

    private static var sunDayKanji: KanjiItem {
        KanjiItem(
            order: 15,
            character: "日",
            meaning: "giorno, sole",
            reading: "にち, じつ / ひ, か",
            category: "N5",
            masteryLevel: .apprentice,
            isFavorite: false,
            trainingStrokes: [
                KanjiStroke(id: 1, strokeType: .vertical, startPoint: CGPoint(x: 0.30, y: 0.20), endPoint: CGPoint(x: 0.30, y: 0.80), cornerPoint: nil, direction: .topToBottom),
                KanjiStroke(id: 2, strokeType: .corner, startPoint: CGPoint(x: 0.30, y: 0.20), endPoint: CGPoint(x: 0.70, y: 0.80), cornerPoint: CGPoint(x: 0.70, y: 0.20), direction: .rightThenDown),
                KanjiStroke(id: 3, strokeType: .horizontal, startPoint: CGPoint(x: 0.30, y: 0.50), endPoint: CGPoint(x: 0.70, y: 0.50), cornerPoint: nil, direction: .leftToRight),
                KanjiStroke(id: 4, strokeType: .horizontal, startPoint: CGPoint(x: 0.30, y: 0.80), endPoint: CGPoint(x: 0.70, y: 0.80), cornerPoint: nil, direction: .leftToRight)
            ],
            exampleWords: [
                KanjiExampleWord(word: "日本", meaning: "Giappone"),
                KanjiExampleWord(word: "日曜日", meaning: "Domenica"),
                KanjiExampleWord(word: "今日", meaning: "Oggi")
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
            completionDate: completionDate
        )
    }
}
