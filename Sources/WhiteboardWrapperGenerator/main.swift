/**                                                                     
 *  /file main.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */                                                                     

import Foundation

import DataStructures
import Config
import FileGenerators
import Parsers

var configDir: String = /*CWD + */ "../"
var tslName: String = "default.tsl"

while case let option = getopt(CommandLine.argc, CommandLine.unsafeArgv, "f:P:"), option != -1 {
    switch UnicodeScalar(CUnsignedChar(option)) {
    case "f":
        tslName = String(cString: optarg)
        print("""
            Legacy option '-f':
            \t  This should be set in WhiteboardWrapperGenerator.config.
            \t  WhiteboardWrapperGenerator.config can override this flag.
            \t  '-f' will be removed at some point.
            """)

    case "P":
        configDir = String(cString: optarg)
    default:
        fatalError("Unknown option")
    }
}

//Load config

//Find tsl from path
let tslFilePath: URL = URL(fileURLWithPath: "/home/carl/src/MiPal/GUNao/posix/gusimplewhiteboard/guwhiteboardtypelist.tsl")

//parse tsl
let container = TSLParser.parse(tslFilePath: tslFilePath)

for warning in container.warnings {
    print("""
    warning: \(warning.toString())
    """)
}

if let error = container.error {
    print("""
    error: \(error.toString())
    """)
    exit(EXIT_FAILURE)
}

//generate files
if let tsl: TSL = container.object {
    let fileGenerator = FileGeneratorManager(tsl: tsl, wbPath: tslFilePath.deletingLastPathComponent())
    fileGenerator.generate()
}

