//
//  PhoneDictionary.swift
//  bobo
//
//  Created by Jim Hsu on 2019/7/4.
//  Copyright © 2019 Tataro.com.tw. All rights reserved.
//

import Foundation

enum DictSource:String, CustomStringConvertible{
    var description: String{
        return self.rawValue
    }
    var filename:String{
        return self.rawValue
    }
    case mini = "mini"
    case RevZhuyin = "RevZhuyin"
    case RevPinyin = "RevPinyin"
    case miniZy2Chars = "miniZy2Chars"
    case toneFullHouseDict = "toneFullHouseDict"
}

struct PhoneDict:Codable{
    
    static let mini:PhoneDict? = fromEmbeddedJson(.mini)
    fileprivate let dictionary:[Character: [String]]
    
    init(_ zhuyin:[Character:[String]]) {
        self.dictionary = zhuyin
    }
    
    func getZhuyin(_ char1:Character)-> [String]{
        return dictionary[char1] ?? [String]()
    }
    
    fileprivate static var RevZhuyin:PhoneDict?
    fileprivate static var RevPinyin:PhoneDict?
    
    fileprivate static func loadRevZhuyin(){
        RevZhuyin = fromEmbeddedJson(.RevZhuyin)
    }
    fileprivate static func loadRevPinyin(){
        RevPinyin = fromEmbeddedJson(.RevPinyin)
    }
    
    fileprivate static func fromEmbeddedJson(_ source:DictSource = .mini ) -> PhoneDict?{
        let url1 = Bundle.main.url(forResource:source.filename, withExtension: "json")
        guard let url = url1 else { return nil }
        if let jsonData = try? Data(contentsOf: url), let dict = try? JSONDecoder().decode(PhoneDict.self, from:jsonData){
            print("\(source.filename) decoded")
            return dict
        }else{
            print("\(source.filename)decode failed")
            return nil
        }
    }
    
}

//tones:[Chars] input is zhuyin, output is [chars] from mini. this enable harness of tts engine from char, as of today, I am not sure there is tts engine by zhuyin
struct ZyToChars:Codable{
    
    static let mini:ZyToChars? = fromEmbeddedJson()
    private let dictionary:[String:[Character]]
    
    fileprivate func removeTonefromZhuyin(_ zy1:String)->String?{
        var ar1:[Character] = Array(zy1)
        let mpsArray:[Mps] = ar1.compactMap({Mps($0)})
        guard mpsArray.count > 0 && mpsArray.count < 5 else {return nil}
        guard let last = mpsArray.last else {return nil }
        if last.type == MpsType.tone {
            _ = ar1.removeLast()
            return String(ar1)
        }else{
            //check first for .
            let first = mpsArray.first
            if first?.type == MpsType.tone{
                var ar2 = [Character]()
                for mps1 in mpsArray{
                    if mps1.type == MpsType.tone{
                        continue
                    }else{
                        ar2.append(mps1.zhuyin)
                    }
                }
                return String(ar2)
            }else{
                return zy1
            }
        }
    }
    
    func get4ToneChars(_ zy1:String) -> [[Character]]{
        let cmr = removeTonefromZhuyin(zy1)
        let cmr1:String = cmr! //+ String(Mps.t1.zhuyin)
        let cmr2:String = cmr! + String(Mps.t2.zhuyin)
        let cmr3:String = cmr! + String(Mps.t3.zhuyin)
        let cmr4:String = cmr! + String(Mps.t4.zhuyin)
        let ar1:[Character] = dictionary[cmr1] ?? [Character]()
        let ar2:[Character] = dictionary[cmr2] ?? [Character]()
        let ar3:[Character] = dictionary[cmr3] ?? [Character]()
        let ar4:[Character] = dictionary[cmr4] ?? [Character]()
        print("@get4ToneChars()\(cmr!):\(ar1.count)-\(ar2.count)-\(ar3.count)-\(ar4.count)")
        return [ar1, ar2, ar3, ar4]
    }
    
    fileprivate static func fromEmbeddedJson(_ source:DictSource = .miniZy2Chars ) -> ZyToChars?{
        let url1 = Bundle.main.url(forResource:source.filename, withExtension: "json")
        guard let url = url1 else { return nil }
        if let jsonData = try? Data(contentsOf: url), let dict = try? JSONDecoder().decode(ZyToChars.self, from:jsonData){
            print("\(source.filename) decoded")
            return dict
        }else{
            print("\(source.filename)decode failed")
            return nil
        }
    }
}
    //save is used to genereate json file, not necessary here,
//    func save(_ name:String = "zy2Char" ) throws {
//        print("\(name) save()")
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        let data = try encoder.encode(self)
//        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("\(name).json"){
//            try data.write(to: url)
//            print("\(name) saved")
//        }else{
//            print("\(name) failed")
//        }
//    }

//tfh is used to figoure char arrays by CMR input. (no tones)
//this helps the tone lessons.
struct ToneFullHouse:Codable{
    let charArry1:[Character]
    let charArry2:[Character]
    let charArry3:[Character]
    let charArry4:[Character]
    let phone:String
    
    var TextOne:String{
        let s1 = charArry1.count > 0 ? String(charArry1[0]) : ""
        let s2 = charArry2.count > 0 ? String(charArry2[0]) : ""
        let s3 = charArry3.count > 0 ? String(charArry3[0]) : ""
        let s4 = charArry4.count > 0 ? String(charArry4[0]) : ""
        return "\(s1)\(s2)\(s3)\(s4)"
    }
}

struct ToneFullHouseDict:Codable{
    static let mini = fromEmbeddedJson()
    fileprivate let dict:[String:ToneFullHouse]
    //let cmrSet:Set<String>
    fileprivate let cmrArray:[String]
    let cmrArrayFyOnly:[String]
    
    fileprivate func removeTonefromZhuyin(_ zy1:String)->String?{
        var ar1:[Character] = Array(zy1)
        let mpsArray:[Mps] = ar1.compactMap({Mps($0)})
        guard mpsArray.count > 0 && mpsArray.count < 5 else {return nil}
        guard let last = mpsArray.last else {return nil }
        if last.type == MpsType.tone {
            _ = ar1.removeLast()
            return String(ar1)
        }else{
            //check first for .
            let first = mpsArray.first
            if first?.type == MpsType.tone{
                var ar2 = [Character]()
                for mps1 in mpsArray{
                    if mps1.type == MpsType.tone{
                        continue
                    }else{
                        ar2.append(mps1.zhuyin)
                    }
                }
                return String(ar2)
            }else{
                return zy1
            }
        }
    }
    
    func getToneFullHouse(char:Character)->ToneFullHouse?{
        guard let mini = PhoneDict.mini else {return nil }
        let array1 = mini.getZhuyin(char)
        
        guard array1.count > 0 else { return nil }
        return getToneFullHouse(zhuyin: array1[0])
    }
    func getToneFullHouse(zhuyin:String) -> ToneFullHouse?{
        if let noTone = removeTonefromZhuyin(zhuyin){
            return dict[noTone]
        }else{
            return nil
        }
    }
    func getToneFullHouse(_ phone:MpsPhone) -> ToneFullHouse?{
        return getToneFullHouse(zhuyin: phone.zhuyin)
    }
    
    fileprivate static func fromEmbeddedJson(_ source:DictSource = .toneFullHouseDict ) -> ToneFullHouseDict?{
        let url1 = Bundle.main.url(forResource:source.filename, withExtension: "json")
        guard let url = url1 else { return nil }
        if let jsonData = try? Data(contentsOf: url), let dict = try? JSONDecoder().decode(ToneFullHouseDict.self, from:jsonData){
            print("\(source.filename) decoded")
            return dict
        }else{
            print("\(source.filename)decode failed")
            return nil
        }
    }
}
//    func save(_ name:String = "toneFullHouseDict" ) throws {
//        print("\(name) save()")
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        let data = try encoder.encode(self)
//        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("\(name).json"){
//            try data.write(to: url)
//            print("\(name) saved")
//        }else{
//            print("\(name) failed")
//        }
//    }


extension Character: Codable {
    public init(from decoder:Decoder) throws {
        //print(decoder.codingPath)
        let container = try decoder.singleValueContainer()
        let s1 = try container.decode(String.self)
        self = Character(s1)
        return
    }
    
    
    public func encode (to encoder: Encoder)throws{
        //print("encodable encode")
        let charString = String(self)
        var container = encoder.singleValueContainer()
        try container.encode(charString)
    }
}
