//
//  mps-ref.swift
//  cmdtool1
//
//  Created by Jim Hsu on 2019/7/15.
//  Copyright © 2019 Tataro.com.tw. All rights reserved.
//

import Foundation

enum Mps: String, CaseIterable, Codable{
    var zhuyin: Character{
        let dict = MpsSift.shared.pinyinDictionary
        if let c1 = dict[self] {
            return c1
        }else{
            fatalError("Mps.zhuyin \(self)")
        }
    }
    var pinyin:String{
        return self.rawValue
    }
    
    var type:MpsType{
        return MpsSift.shared.getType(self)
    }
    
    init?(_ char1:Character){
        if let mps1:Mps =  MpsSift.shared.zhuyinDictionary[char1]{
            self = mps1
            return
        }else{
            return nil
        }
    }
    case b, p, m, f, d, t, n, l, g, k, h, j, q , x , zh , ch, sh, r, z, c, s, i, y, u, w, yu, ü, a, o , e, eh, ai , ei , ao , ou , an, en , ang, ng ,eng , er
    
    
    ///tone:
    case t1 = "1"
    case t2 = "2"
    case t3 = "3"
    case t4 = "4"
    case t5 = "5" //"˙ㄉㄜ" in moedict
    
}

extension Mps{
    
    static let bpmf:[Mps] = [.b, .p, .m, .f]
    static let dtnl:[Mps] = [.d,.t, .n, .l]
    static let ghk:[Mps] = [.g, .k, .h]
    static let jqx:[Mps] = [.j, .q, .x]
    static let zhchshr:[Mps] = [.zh, .ch, .sh, .r]
    static let zcs:[Mps] = [.z, .c, .s ]
    static let iuü:[Mps] = [.i, .u,  ü]
    static let aoeeh:[Mps] = [.a, .o, .e, .eh]
    static let aieiaoou:[Mps] = [.ai, .ei, .ao, .ou]
    static let anenangng:[Mps] = [.an, .en, .ang, .ng]
    static let tones4:[Mps] = [.t1, .t2, .t3, .t4]
}

enum MpsType: Int, Codable{
    case tone, consonant, medial, rhyme
    
}

//MARK: helper object MpsSift
struct MpsSift{
    
    static let shared = MpsSift()
    
    func getType(_ mps1:Mps) -> MpsType{
        if tones.contains(mps1){
            return .tone
        }else if pinyinConsonant.contains(mps1){
            return .consonant
        }else if pinyinRhyme.contains(mps1){
            return .rhyme
        }else if pinyinMedia.contains(mps1){
            return .medial
        }else{
            fatalError("Mps:\(mps1)")
        }
    }
    func getType(_ char1:Character) -> MpsType{
        if zhuyinTones.contains(char1){
            return .tone
        }else if zhuyinConsonant.contains(char1){
            return .consonant
        }else if zhuyinRhyme.contains(char1){
            return .rhyme
        }else if zhuyinMedial.contains(char1){
            return .medial
        }else{
            fatalError("invalid char for Mps:\(char1)")
        }
    }
    let pinyinDictionary: [Mps:Character] = [
        .b: "ㄅ",.p: "ㄆ", .m: "ㄇ", .f:"ㄈ", .d: "ㄉ",.t: "ㄊ" ,.n: "ㄋ", .l:"ㄌ", .g: "ㄍ",.k: "ㄎ" ,.h: "ㄏ", .j:"ㄐ", .q: "ㄑ",.x: "ㄒ" ,.zh: "ㄓ", .ch: "ㄔ", .sh: "ㄕ", .r: "ㄖ", .z : "ㄗ", .c : "ㄘ", .s : "ㄙ",
        .y : "ㄧ", .w : "ㄨ", .yu : "ㄩ",  .i : "ㄧ" , .u : "ㄨ" , .ü : "ㄩ",
        .a:"ㄚ", .o :"ㄛ" , .e : "ㄜ" , .eh : "ㄝ", .ai : "ㄞ" , .ei : "ㄟ", .ao : "ㄠ" , .ou : "ㄡ" , .an : "ㄢ", .en : "ㄣ" , .ang : "ㄤ", .ng: "ㄥ",  .eng : "ㄥ", .er : "ㄦ",
        .t1 : "ˉ", .t2: "ˊ", .t3 : "ˇ" , .t4 : "ˋ", .t5 : "˙"
    ]
    let zhuyinDictionary:[Character:Mps] = [
        "ㄅ":.b , "ㄆ":.p , "ㄇ": .m , "ㄈ" : .f, "ㄉ" :.d ,"ㄊ": .t ,"ㄋ" : .n , "ㄌ": .l, "ㄍ": .g ,  "ㄎ": .k , "ㄏ": .h , "ㄐ": .j, "ㄑ": .q ,"ㄒ": .x ,"ㄓ": .zh , "ㄔ": .ch, "ㄕ": .sh, "ㄖ": .r , "ㄗ": .z, "ㄘ": .c , "ㄙ" : .s ,
        "ㄧ": .i , "ㄨ" : .u ,"ㄩ" : .ü ,
        "ㄚ": .a,"ㄛ" : .o , "ㄜ" : .e, "ㄝ": .eh , "ㄞ" : .ai , "ㄟ" : .ei ,"ㄠ" : .ao , "ㄡ": .ou ,"ㄢ" : .an , "ㄣ" : .en ,  "ㄤ": .ang, "ㄥ": .ng , "ㄦ": .er ,
        "ˉ": .t1 ,"ˊ" : .t2, "ˇ": .t3 ,"ˋ":  .t4 ,"˙": .t5
    ]
    //    func zhuyinType(_ mps1:Character)-> (PhoneType, Character) {
    //        return (PhoneType.consonant, Mps.b.char)
    //    }
    let tones:Set<Mps> = [Mps.t1,.t2, .t3, .t4, .t5 ]
    let zhuyinTones:Set<Character> = ["ˉ", "ˊ", "ˇ", "ˋ","˙"]
    //let toneNum:Set<Character> = ["1", "2", "3", "4", "5"]
    let pinyinConsonant:Set<Mps> = [.b,.p, .m, .f, .d,.t ,.n, .l, .g,.k ,.h, .j, .q,.x ,.zh, .ch, .sh, .r, .z, .c, .s]
    //    let pinyinConsonant:Set<String> = ["b", "p", "m", "f", "d", "t", "n", "l", "g", "k", "h", "j", "q" , "x" , "zh" , "ch", "sh", "r", "z", "c", "s"]
    let pinyinMedia:Set<Mps> = [.i, .u, .ü, .y, .w, .yu]
    let pinyinRhyme:Set<Mps> = [.a, .o, .e, .eh, .ai, .ei, .ao, .ou, .an, .en, .ang, .en, .ng, .eng, .er ]
    let zhuyinConsonant:Set<Character> = ["ㄅ", "ㄆ", "ㄇ","ㄈ","ㄉ","ㄊ","ㄋ","ㄌ","ㄍ","ㄎ","ㄏ","ㄐ","ㄑ" ,"ㄒ","ㄓ" ,"ㄔ", "ㄕ","ㄖ","ㄗ","ㄘ", "ㄙ"]
    
    let zhuyinMedial:Set<Character>=["ㄧ","ㄨ","ㄩ"]
    let zhuyinRhyme:Set<Character>=["ㄚ","ㄛ" ,"ㄜ", "ㄝ", "ㄞ" ,"ㄟ" ,"ㄠ" ,"ㄡ" ,"ㄢ", "ㄣ" ,"ㄤ","ㄥ" ,"ㄦ"]
}

//new design phone is for combo only, and there will be tone.
//tone.1 will be default if omitted
// no init? from pinyin since we can always get it from zhuyin dict now. pinyin is not fixed lengh... and it varies.
struct MpsPhone{
    
    let tone:Mps
    let consonant:Mps?
    let rhyme:Mps?
    let medial:Mps?
    
    //word can vary since we focus on zhuyin.
    var word:Character? = nil
    
    ///since no popfirst, alternative[0] = origin, duplications...
    var alternativeZhuyin = [String]()
    var alternativePinyin = [String]()
    
    let sift = MpsSift.shared
    
    let pinyin:String
    let zhuyin:String
    
    
    
    //symbol enum input
    ///the lastone need to be tone
    init?(_ mps:[Mps]){
        guard mps.count > 0 && mps.count < 5 else { return nil }
        //if mps.count == 1 && sift.getType(mps[0]) == .tone { return nil } //1 and tone only invalid
        var cmrCount:Int
        guard let last = mps.last else { return nil }
        if last.type == MpsType.tone {
            self.tone = last
            cmrCount = mps.count - 1
        }else{
            guard mps.count < 4 else { return nil }
            self.tone = .t1
            cmrCount = mps.count
        }
        ///tone has been extracted, only CMR
        switch cmrCount{
        case 1: //no tone, tone = 1
            switch sift.getType(mps[0]){
            case .consonant:
                return nil
            case .rhyme:
                consonant = nil
                medial = nil
                rhyme = mps[0]
            case .medial:
                consonant = nil
                medial = mps[0]
                rhyme = nil
            default:
                return nil
            }
        case 2:
            switch sift.getType(mps[0]){
            case .medial:
                consonant = nil
                medial = mps[0]
                rhyme = mps[1]
            case .consonant:
                consonant = mps[0]
                switch sift.getType(mps[1]){
                case .medial:
                    medial = mps[1]
                    rhyme = nil
                case .rhyme:
                    medial = nil
                    rhyme = mps[1]
                default:
                    return nil
                }
            case .rhyme:
                return nil
            default:
                return nil
            }
        case 3:
            consonant = mps[0]
            medial = mps[1]
            rhyme = mps[2]
        default:
            fatalError()
        }
        let mpsAry:[Mps?] = [consonant, medial, rhyme, tone]
        var s1:String = ""
        var charAry:[Character] = [Character]()
        for mps1 in mpsAry{
            if let mps1 = mps1{
                s1 = s1 + mps1.pinyin
                charAry.append(mps1.zhuyin)
            }
        }
        pinyin = s1
        zhuyin = String(charAry)
        //print("\(self): \(self.pinyin) \(self.zhuyin)")
    }
    
    
    //symbol, flat text
    init?(zhuyin:String){
        let ar1:[Character] = Array(zhuyin)
        let mpsArray:[Mps] = ar1.compactMap({Mps($0)})
        self.init(mpsArray)
        
    }
    
//    init?(_ word:Character){
////        guard let mini = PhoneDict.mini?.dictionary else { print("!MiniZhuyin"); return nil }
////        if let zhuyinAry = mini[word]{
////            self.init(zhuyin:zhuyinAry[0])
////            self.word = word
////            if zhuyinAry.count > 1{
////                self.alternativeZhuyin = zhuyinAry
////            }
////        }else{
////            print("Mps.Init(\(word) failed")
////            return nil
////        }
//    }
    
}
