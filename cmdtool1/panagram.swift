//
//  panagram.swift
//  cmdtool1
//
//  Created by Jim Hsu on 2019/6/28.
//  Copyright © 2019 Tataro.com.tw. All rights reserved.
//
class Panagram {
    
    let consoleIO = ConsoleIO()
    let noodle = Noodle.shared
    
    func staticMode() {
        consoleIO.printUsage()
        noodle.json1()
    }
    
}
