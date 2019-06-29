//
//  noodle.swift
//  cmdtool1
//
//  Created by Jim Hsu on 2019/6/29.
//  Copyright © 2019 Tataro.com.tw. All rights reserved.
// https://forums.developer.apple.com/thread/90293

import Foundation

class Noodle{
    
    
    static let shared = Noodle()
    let consoleIO = ConsoleIO()

    
    func json1(){
        let dict = miniDict([
            CharPhone("團", "ㄊㄨㄢˊ"),
            CharPhone("圓", "ㄩㄢˊ"),
            CharPhone("漂", ["ㄆㄧㄠ", "ㄆㄧㄠˇ","ㄆㄧㄠˋ"])
            ])
        do{
            try dict.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func process(_ text:String) throws {
        //print(text)
        var charPhones = [CharPhone]()
        let lines = text.split(separator: "\r\n")
        for line in lines.enumerated(){
                let cols = line.element.split(separator: "\t")
                assert(cols.count == 2)
                let str1:String = String(cols[0])
                print(str1)
                let ch1:Character = Character(str1)
                let delChar = CharacterSet.init(charactersIn:"\"")
                let trim = cols[1].trimmingCharacters(in: delChar)
                let zhuyins = trim.split(separator: "\n")
                print("\(trim) --- \(zhuyins) \(zhuyins.count)")
                charPhones.append(CharPhone(ch1, zhuyins.compactMap({String($0)})))
        }
        let dict1 = miniDict(charPhones)
        do{
            try dict1.save()
        }catch{
            consoleIO.writeMessage(error.localizedDescription, to: .error)
        }
    }
    
    
    func processFile(at url: URL) throws{
        let s = try String(contentsOf: url)
        try process(s)
    }
    
    func processBundleFile(_ name:String, _ ext:String){
        guard let filePath = Bundle.main.url(forResource: name , withExtension: ext) else {
            print("fail to locate \(name).\(ext)");return }
        do{
            let s = try String(contentsOf: filePath)
            try process(s)
        }catch{
            consoleIO.writeMessage(error.localizedDescription, to: .error)
        }
        consoleIO.writeMessage("fin")
    }
    
    func staticMode(){
        main()
    
    }
    
    func desktop1(){
        let home = FileManager.default.homeDirectoryForCurrentUser
        let file1 = "Desktop/zhuyin1.tsv"
        let url1 = home.appendingPathComponent(file1)
        do{
            try processFile(at: url1)
        }catch{
             consoleIO.writeMessage("error processing: \(url1): \(error)", to: .error)
        }
    }
    
    func main(){
        guard CommandLine.arguments.count > 1 else {
            consoleIO.writeMessage("usage: \(CommandLine.arguments[0]) file...")
            desktop1()
            return
        }
        for path in CommandLine.arguments[1...] {
            do {
                let u = URL(fileURLWithPath: path)
                try processFile(at: u)
            } catch {
                consoleIO.writeMessage("error processing: \(path): \(error)", to: .error)
            }
        }
    }
}
