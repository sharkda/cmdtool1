//
//  miniDict.swift
//  cmdtool1
//
//  Created by Jim Hsu on 2019/6/28.
//  Copyright © 2019 Tataro.com.tw. All rights reserved.
import Foundation

struct CharPhone01: Codable {
    let character: Character
    let zhuyins:[String]
    
    init( _ char: Character, _ zhuyin1:String){
        character = char
        self.zhuyins = [zhuyin1]
    }
    init (_ char:Character, _ zhuyins:[String]){
       character = char
       self.zhuyins = zhuyins
    }
    
    enum CodingKeys: String, CodingKey{
        case character = "chr"
        case zhuyins = "zhy"
    }

    //TODO:parse the text/csv file. notice how to handle the alternative!
    init(text:String)
    {
        fatalError("parse the txt file.")
    }
}

struct PhoneDict:Encodable{
    
    //var path0:String = "OneDrive\farms\json"
    
    let dictionary:[Character: [String]]
    
    init(_ dict:[Character:[String]]) {
        self.dictionary = dict
    }
    
    func save(_ name:String = "zhuyin", path0:String = "OneDrive/farms/json/") throws {
        print("\(path0)\(name) save()")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("\(path0)\(name).json"){
            try data.write(to: url)
            print("\(name) saved")
        }else{
            print("\(name) failed")
        }
    }
}

struct ToneFullHouseDict:Encodable{
    let dict:[String:ToneFullHouse]
    //let cmrSet:Set<String>
    let cmrArray:[String]
    let cmrArrayFyOnly:[String]
    
    func removeTonefromZhuyin(_ zy1:String)->String?{
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
    
    func getToneFullHouse(_ zhuyin:String) -> ToneFullHouse?{
        if let noTone = removeTonefromZhuyin(zhuyin){
            return dict[noTone]
        }else{
            return nil
        }
    }
    
    func save(_ name:String = "toneFullHouseDict" ) throws {
        print("\(name) save()")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("\(name).json"){
            try data.write(to: url)
            print("\(name) saved")
        }else{
            print("\(name) failed")
        }
    }
}

struct ToneFullHouse:Encodable{
    let charArry1:[Character]
    let charArry2:[Character]
    let charArry3:[Character]
    let charArry4:[Character]
    let phone:String
}

//tones: [chars]
struct ZyToChars:Encodable{
    let dictionary:[String:[Character]]
    
    func removeTonefromZhuyin(_ zy1:String)->String?{
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
    
    func save(_ name:String = "zy2Char" ) throws {
        print("\(name) save()")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("\(name).json"){
            try data.write(to: url)
            print("\(name) saved")
        }else{
            print("\(name) failed")
        }
    }
}



struct MiniArray:Encodable, Decodable{
    var charPhones = [CharPhone01]()

    init(_ cps:[CharPhone01])
    {
        charPhones = cps
        print("@MiniArray \(charPhones.count)")
    }
    func save() throws {
        print("miniArray.Save()")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("miniArray.json"){
            try data.write(to: url)
            print("saved")
        }else{
            print("failed")
        }
    }
}

struct VocabularySets:Codable{
    let s1:Set<Character>  //100
    let s2:Set<Character>
    
    func save(_ name:String = "vocabulary" ) throws {
        print("\(name) save()")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("\(name).json"){
            try data.write(to: url)
            print("\(name) saved")
        }else{
            print("\(name) failed")
        }
    }
}

////MARK: decode extension will fail. so I change the scene to use string as internal storage
//extension Character: Codable {
//    public init(from decoder:Decoder) throws {
//        //print(decoder.codingPath)
//        let container = try decoder.singleValueContainer()
//        let s1 = try container.decode(String.self)
//        self = Character(s1)
//        return
//    }
//    
//    
//    public func encode (to encoder: Encoder)throws{
//        //print("encodable encode")
//        let charString = String(self)
//        var container = encoder.singleValueContainer()
//        try container.encode(charString)
//    }
//}
