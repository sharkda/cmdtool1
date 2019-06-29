//
//  consoleIO.swift
//  cmdtool1
//
//  Created by Jim Hsu on 2019/6/28.
//  Copyright © 2019 Tataro.com.tw. All rights reserved.
// https://www.raywenderlich.com/511-command-line-programs-on-macos-tutorial


import Foundation

enum OutputType {
    case error
    case standard
}

class ConsoleIO{
    func writeMessage(_ message: String, to: OutputType = .standard) {
        switch to {
        case .standard:
            print("\(message)")
        case .error:
            fputs("Error: \(message)\n", stderr)
        }
    }
    
    func printUsage1(){
        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
        writeMessage("usage: \(executableName) file...")
    }
    
    func printUsage() {
        
        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
        
        writeMessage("usage:")
        writeMessage("\(executableName) -a string1 string2")
        writeMessage("or")
        writeMessage("\(executableName) -p string")
        writeMessage("or")
        writeMessage("\(executableName) -h to show usage information")
        writeMessage("Type \(executableName) without an option to enter interactive mode.")
    }
}
