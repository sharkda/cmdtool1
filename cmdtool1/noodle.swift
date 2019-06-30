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
    }
    
    
    func processFile(at url: URL) throws{
        let s = try String(contentsOf: url)
        try process(s)
    }
    
    func trimRev(_ text:String) -> String{
        let delChar = CharacterSet.init(charactersIn:" (一) (二) (三) (四) （又音） (語音) (讀音）")
        return text.trimmingCharacters(in: delChar)
    }
    
    /*
     Only 1 arrays of RevX (all 1,2,3,4 or 4+)
     
     Dictionary.Init( groping: char, entireObject)
     now I should get a  dict like
     //[“char1”: [charphone2, charphone2,…]]
     need to reduce that into one charphone2
    */
    func processRev(at url: URL) throws{
        let text = try String(contentsOf: url)
        //var charPhones = [CharPhone]()
        var invalids = [String]()
        var rev0s = [CharPhone2]()
        //var rev1s = [CharPhone2]() // new
        var revXs = [CharPhone2]()
        let lines = text.split(separator: "\r\n")
        for line in lines.enumerated(){
           
            let cols = line.element.split(separator: "\t")
            //print("\(String(line.element))--\(cols.count)")
            assert(cols.count == 4)
            //print("\(cols[1])  \(cols[2]) \(cols[3])")
            if String(cols[1]).hasPrefix("&")
            {
                //print("hasprefix(&)\(cols[1])")
                let raw = String(line.element)
                invalids.append(raw)
            }else{
                let zy = String(cols[2])
                let py = String(cols[3])
                let no:Int = Int(String(cols[0])) ?? 0
                let zy1 = trimRev(zy)
                let py1 = trimRev(py)
                let cp2 = CharPhone2(Character(String(cols[1])), zy1, py1, no)
                if String(cols[2]).hasPrefix("("){
//                    if String(cols[2]).hasPrefix("(一)"){
//                        rev1s.append(cp2)
//                    }else{
                        revXs.append(cp2)
//                    }
                }else{
                     let cp2 = CharPhone2(Character(String(cols[1])), zy, py, no)
                    rev0s.append(cp2)
                }
            }
        }
        let invalid:NoneProcessd = NoneProcessd(leftover: invalids, fileName: "invalid")
        let rev0:RevisedDict = RevisedDict(rev0s, "rev0")
        //let rev1:RevisedDict = RevisedDict(rev1s, "rev1")
        let revX:RevisedDict = RevisedDict(revXs, "revX")
        let revMultList = mapReduce(revXs)
        let revMulti:RevisedDict = RevisedDict(revMultList,"revMulti")
        
//        let dict1 = miniDict(charPhones)
        do{
//            try dict1.save()
              try invalid.save()
              try rev0.save()
              //try rev1.save()
              try revX.save()
              try revMulti.save()
        }catch{
            consoleIO.writeMessage(error.localizedDescription, to: .error)
        }
    }
    
    func mapReduce(_ revXs:[CharPhone2]) -> [CharPhone2]{
        let dict = Dictionary(grouping: revXs, by: {$0.character})
        print("mapReduce()-revXs \(dict.count)")
        var cpx = [CharPhone2]()
        for (char, cps ) in dict{
            print("char:\(char) \(cps.count)")
            var zhy = [String]()
            var pny = [String]()
            var num = [Int]()
            for cp2 in cps{
                zhy.append(cp2.zhuyins[0])
                pny.append(cp2.pinyins[0])
                num.append(cp2.refs[0])
            }
            cpx.append(CharPhone2(char, zhy, pny, num))
        }
        return cpx
    }
    
//    ///jh:not working since duplicated records within "one"
//    func multiMerge(_ rev1s:[CharPhone2], _ revXs:[CharPhone2]) -> [CharPhone2]{
//        let dict1 = Dictionary(uniqueKeysWithValues: rev1s.map({($0.character, $0)}))
//        print(dict1)
//        //let merged = Array(Dictionary([rev1s, revXs].joined()
//        return [CharPhone2]()
//    }
    
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
    //MARK: Desktopzhuyin1.tsv
    func desktopRev(){
        let home = FileManager.default.homeDirectoryForCurrentUser
        let file1 = "Desktop/dictRev.tsv"
        let url1 = home.appendingPathComponent(file1)
        do{
            try processRev(at: url1)
        }catch{
            consoleIO.writeMessage("error processing: \(url1): \(error)", to: .error)
        }
    }
    
    //MARK: Desktopzhuyin1.tsv
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
            //desktop1()
            desktopRev()
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
