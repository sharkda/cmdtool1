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

    
//    func json1(){
//        let dict = miniDict([
//            CharPhone("團", "ㄊㄨㄢˊ"),
//            CharPhone("圓", "ㄩㄢˊ"),
//            CharPhone("漂", ["ㄆㄧㄠ", "ㄆㄧㄠˇ","ㄆㄧㄠˋ"])
//            ])
//        do{
//            try dict.save()
//        }catch{
//            print(error.localizedDescription)
//        }
//    }
    
    func process(_ text:String) throws {
        //print(text)
        var charPhones = [CharPhone]()
        let lines = text.split(separator: "\r\n")
        for line in lines.enumerated(){
                let cols = line.element.split(separator: "\t")
                assert(cols.count == 2)
                let str1:String = String(cols[0])
                //print(str1)
                let ch1:Character = Character(str1)
                let delChar = CharacterSet.init(charactersIn:"\"")
                let trim = cols[1].trimmingCharacters(in: delChar)
                let zhuyins = trim.split(separator: "\n")
                //print("\(trim) --- \(zhuyins) \(zhuyins.count)")
                charPhones.append(CharPhone(ch1, zhuyins.compactMap({String($0)})))
        }
        let array1 = MiniArray(charPhones)
        let zhuyinDict = Dictionary(uniqueKeysWithValues: array1.charPhones.map{($0.character, $0.zhuyins)})
        let mini1 = PhoneDict(zhuyinDict)
        do{
            try array1.save()
            try mini1.save("mini")
        }catch{
            consoleIO.writeMessage(error.localizedDescription, to: .error)
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
        var rev1s = [CharPhone2]() // new
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
                    if String(cols[2]).hasPrefix("(一)"){
                        rev1s.append(cp2)
                    }else{
                        revXs.append(cp2)
                    }
                }else{
                     let cp2 = CharPhone2(Character(String(cols[1])), zy, py, no)
                    rev0s.append(cp2)
                }
            }
        }
        //let invalid:NoneProcessd = NoneProcessd(leftover: invalids, fileName: "invalid")
        //let rev0:RevisedDict = RevisedDict(rev0s, "rev0")
        let count0 = rev0s.count
        //let rev1:RevisedDict = RevisedDict(rev1s, "rev1")
        //let revX:RevisedDict = RevisedDict(revXs, "revX")
        let countx = revXs.count
        //let revMultList = mapReduce(revXs)
        let revMultList = BaseAndAlt(rev1s, revXs)
        let countXReduced = revMultList.count
        let revMulti:RevisedDict = RevisedDict(revMultList,"revMulti")
        
        rev0s.append(contentsOf: revMultList)
        print("dictCount: \(count0) + \(countx)::\(countXReduced) rev0s\(rev0s.count)")
        //let revArray:RevisedDict = RevisedDict(rev0s, "revDict")
        
        //let array1 = MiniArray(charPhones)
        //let zhuyinDict = Dictionary(uniqueKeysWithValues: array1.charPhones.map{($0.character, $0.zhuyins)})
        let revMultiZhuyin = Dictionary(uniqueKeysWithValues: revMultList.map({($0.character, $0.zhuyins)}))
        let revMultiZhuyinDict = PhoneDict(revMultiZhuyin)
        let zhuyinDict = Dictionary(uniqueKeysWithValues: rev0s.map({($0.character, $0.zhuyins)}))
        let revZhuyin = PhoneDict(zhuyinDict)
        let pinyinDict = Dictionary(uniqueKeysWithValues: rev0s.map({($0.character, $0.pinyins)}))
        let revPinyin = PhoneDict(pinyinDict)
//        let dict1 = miniDict(charPhones)
        do{
//            try dict1.save()
//              try invalid.save()
//              try rev0.save()
//              //try rev1.save()
//              try revX.save()
//              try revMulti.save()
//              try revArray.save()
                try revZhuyin.save("RevZhuyin")
                try revPinyin.save("RevPinyin")
                try revMultiZhuyinDict.save("revMultiZhuyin")
            
        }catch{
            consoleIO.writeMessage(error.localizedDescription, to: .error)
        }
    }
    func BaseAndAlt(_ rev1:[CharPhone2], _ revx:[CharPhone2]) -> [CharPhone2]{
        let dict1 = Dictionary(grouping: rev1, by: {$0.character})
        let dictX = Dictionary(grouping: revx, by:{$0.character})
        print("dict1 \(dict1.count); dictX \(dictX.count)")
        var cpx = [CharPhone2]()
        for (char, cps) in dict1{
            var zhy = [String]()
            var pny = [String]()
            var num = [Int]()
            for cp2 in cps{
                zhy.append(contentsOf: cp2.zhuyins)
                pny.append(contentsOf: cp2.pinyins)
                num.append(contentsOf: cp2.refs)
            }
            if let cp3 = dictX[char] {
                for cp2 in cp3{
                    zhy.append(contentsOf: cp2.zhuyins)
                    pny.append(contentsOf: cp2.pinyins)
                    num.append(contentsOf: cp2.refs)
                }
            }
            cpx.append(CharPhone2(char, zhy, pny, num))
        }
        return cpx
    }
    
    func mapReduce(_ revXs:[CharPhone2]) -> [CharPhone2]{
        let dict = Dictionary(grouping: revXs, by: {$0.character})
        print("mapReduce()-revXs \(dict.count)")
        var cpx = [CharPhone2]()
        for (char, cps ) in dict{
            //print("char:\(char) \(cps.count)")
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
    
    //MARK:Entry point 
    func staticMode(){
        
        toneMaker()
        
        //desktop1()
        //desktopRev()
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
    
    //MARK:1. char-zhuyin, normalized, 1-M -> 1-1, step2: generat the bag of zhuyin , step3, generate the dict of zhuyin to char, step 4, need a func that can return a structure of the same zhuyin with various tones and the arry of each tones...
    
    
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
    
    func toneMaker(){
        let home = FileManager.default.homeDirectoryForCurrentUser
        let file1 = "Desktop/zhuyin1.tsv"
        let url1 = home.appendingPathComponent(file1)
        var zhuyinSet = Set<String>()
        do{
            let text = try String(contentsOf: url1)
            var charPhones = [CharPhone]()
            let lines = text.split(separator: "\r\n")
            for line in lines.enumerated(){
                let cols = line.element.split(separator: "\t")
                assert(cols.count == 2)
                let str1:String = String(cols[0])
                //print(str1)
                let ch1:Character = Character(str1)
                let delChar = CharacterSet.init(charactersIn:"\"")
                let trim = cols[1].trimmingCharacters(in: delChar)
                let zhuyins = trim.split(separator: "\n")
                //print("\(trim) --- \(zhuyins) \(zhuyins.count)")
                charPhones.append(CharPhone(ch1, zhuyins.compactMap({String($0)})))
                for zy in zhuyins{
                    zhuyinSet.insert(String(zy))
                }
                //print("&charphone\(ch1) delta: \(zhuyinSet.count)")
            }
            let array1 = MiniArray(charPhones)
            let zhuyinDict = Dictionary(uniqueKeysWithValues: array1.charPhones.map{($0.character, $0.zhuyins)})
            let mini1 = PhoneDict(zhuyinDict)
            
            var zy2Chars = [String:[Character]]()
            for zy in zhuyinSet{
                var charArray = [Character]()
                for charPhone1 in charPhones{
                    for zy1 in charPhone1.zhuyins{
                        if zy1 == zy {
                            charArray.append(charPhone1.character)
                            //print("&\(zy1) + \(charPhone1.character)")
                            continue
                        }
                    }
                }
                if charArray.count > 0 {
                    zy2Chars[zy] = charArray
                    print("&\(zy):\(charArray.count)")
                }
            }
            let zy2CharsDict = ZyToChars(dictionary: zy2Chars)
            
            do{
                try zy2CharsDict.save("miniZy2Chars")
                try array1.save()
                try mini1.save("mini")
            }catch{
                consoleIO.writeMessage(error.localizedDescription, to: .error)
            }
            
        }catch{
            consoleIO.writeMessage("error processing: \(url1): \(error)", to: .error)
        }
    }
    
    func tsv2Json(){
        //desktop1() //minidict
        //desktopRev() //reviDict!
    }
    
    func main(){
        guard CommandLine.arguments.count > 1 else {
            consoleIO.writeMessage("usage: \(CommandLine.arguments[0]) file...")
            //tsv2Json()
            
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
