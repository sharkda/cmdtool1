//
//  RevisedDict.swift
//  cmdtool1
//
//  Created by Jim Hsu on 2019/6/30.
//  Copyright © 2019 Tataro.com.tw. All rights reserved.
//

import Foundation
///zy and PY are arrays. 
struct CharPhone: Codable, Hashable {
    let character: Character
    var zhuyins:[String]
    var pinyins:[String]
    let refs:[Int]
    
    init( _ char: Character, _ zhuyin1:String, _ pinyin1:String, _ number:Int){
        character = char
        self.zhuyins = [zhuyin1]
        self.pinyins = [pinyin1]
        self.refs = [number]
    }
    init (_ char:Character, _ zhuyins:[String], _ pinyins:[String], _ numbers:[Int]){
        character = char
        self.zhuyins = zhuyins
        self.pinyins = pinyins
        self.refs = numbers
    }
    
    enum CodingKeys: String, CodingKey{
        case character = "chr"
        case zhuyins = "zhy"
        case pinyins = "pny"
        case refs = "rfs"
    }
    
    //TODO:parse the text/csv file. notice how to handle the alternative!
    init(_ rawRecord:String)
    {
        fatalError("parse the txt file.")
    }
}

enum RawType:Int, Codable{
    case invalidChar = 0, multi1, muliti2, multi3, multi4, multiX
}

//struct sortedRaw:Codable{
//    let type:RawType
//    let text:String
//}

struct NoneProcessd:Codable{
    
    var leftover = [String]()
    let fileName:String
    
    func save() throws {
        print("leftover")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("\(fileName).json"){
            try data.write(to: url)
            print("\(fileName) saved")
        }else{
            print("\(fileName ) failed")
        }
    }
}

struct RevisedDict:Codable{
    
    var charPhones = [CharPhone]()
    let name:String
    
    init(_ cps:[CharPhone], _ name:String)
    {
        charPhones = cps
        self.name = name
    }
    func save() throws {
        print("revDict.Save()")
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
