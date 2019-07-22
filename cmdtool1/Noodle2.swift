//
//  Noodle2.swift
//  cmdtool1
//
//  Created by Jim Hsu on 2019/7/21.
//  Copyright © 2019 Tataro.com.tw. All rights reserved.
//

import Foundation

class Noodle2{
    
    static let shared = Noodle2()
    let consoleIO = ConsoleIO()
    
    func staticMode(){
        //e12Text()
        IterateMps()
    }
    
    func IterateMps(){
        let listMps = Mps.allCases
        for mps1 in listMps{
            print("\(mps1.rawValue):\(mps1.zhuyin)")
        }
    }
    
    
    func e12Text(){
        guard let raw:String = openDeskTopTextFile("e12.txt") else { return }
        let cleansed:String = raw.remove(noiseSet)
        //print(cleansed)
        do{
            try saveTextFile(cleansed, "e12a.txt")
        }catch{
            print(error.localizedDescription)
        }
    }
    
    let noise = "ǜǚōabcdefghijklmnopqrstuvwxyzàáâäãāèéêëēėęûüùúūîïíīįì(zàixiàng)xiàngzuò(diǎnzhào 22、(jǐng(xiāng(miàn(wàng(xiǎng(niàn)1234567890wángcóng biān (zhè) (jìn(dào)(bèi)(yuán) nánài(xiā(pǎo(chuī(dìkuài)lè(lǎ(slā)(bǎ)ěhuóhòngchīliàkǔ)xuéfēichángwènjiānhuǒbàgòngqìfēnàoméiwèixuǎnběinánjiānghúqiūzhīxīngxuěbāngqǐjiùqiúwántiàotáoshùgānglángèzuò"
    lazy var noiseArray = Array(noise)
    lazy var noiseSet = Set(noiseArray.map({$0}))
    
    func openDeskTopTextFile(_ name:String) -> String? {
        let home = FileManager.default.homeDirectoryForCurrentUser
        let file1 = "Desktop/\(name)"
        let url1 = home.appendingPathComponent(file1)
        var text:String
        do{
            text = try String(contentsOf: url1)
            return text
        }catch{
            consoleIO.writeMessage("error processing: \(url1): \(error)", to: .error)
            return nil
        }
    }
    
    func saveTextFile(_ text:String, _ name:String = "untitled.txt" ) throws {
        print("\(name) save()")
    
        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("\(name)"){
            try text.write(to:url, atomically: false, encoding: .utf8)
            print("\(name) saved")
        }else{
            print("\(name) failed")
        }
    }
}

extension String{
    func remove(_ bags:Set<Character>) -> String{
        let me = Array(self)
        var cleansed = [Character]()
        for ch1 in me{
            if bags.contains(ch1){
                continue
            }else{
                cleansed.append(ch1)
            }
        }
        return String(cleansed)
    }
}
