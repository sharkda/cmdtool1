//
//  miniDict.swift
//  cmdtool1
//
//  Created by Jim Hsu on 2019/6/28.
//  Copyright © 2019 Tataro.com.tw. All rights reserved.
import Foundation

struct CharPhone: Codable {
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
        case zhuyins = "zys"
    }

    //TODO:parse the text/csv file. notice how to handle the alternative!
    init(text:String)
    {
        fatalError("parse the txt file.")
    }
}

struct miniDict:Encodable, Decodable{
    var charPhones = [CharPhone]()

    init(_ cps:[CharPhone])
    {
        charPhones = cps 
    }
    func save() throws {
        print("miniDict.Save()")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("miniDict.json"){
            try data.write(to: url)
            print("saved")
        }else{
            print("failed")
        }
    }
}

//MARK: decode extension will fail. so I change the scene to use string as internal storage
extension Character: Codable {
    public init(from decoder:Decoder) throws {
        //print(decoder.codingPath)
        let container = try decoder.singleValueContainer()
        let s1 = try container.decode(String.self)
        self = Character(s1)
        return
    }
    
    
    public func encode (to encoder: Encoder)throws{
        print("encodable encode")
        let charString = String(self)
        var container = encoder.singleValueContainer()
        try container.encode(charString)
    }
}
