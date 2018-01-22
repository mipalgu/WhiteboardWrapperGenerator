/**                                                                     
 *  /file main.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */                                                                     

import Foundation

import DataStructures
import FileGenerators
import Parsers

var configDir: String = /*CWD + */ "../"
var tslNameFlag: String?

while case let option = getopt(CommandLine.argc, CommandLine.unsafeArgv, "f:P:"), option != -1 {
    switch UnicodeScalar(CUnsignedChar(option)) {
    case "f":
        tslNameFlag = String(cString: optarg)
        print("""
            Legacy option '-f':
                This should be set in WhiteboardWrapperGenerator.config.
                This will override the value in WhiteboardWrapperGenerator.config.
                '-f' will be removed at some point.
            """)

    case "P":
        print("""
            Legacy option '-P':
                -P is depricated, please use -I instead.
                They are functionally the same.
                '-P' will be removed at some point.
            """)
        configDir = String(cString: optarg)
    case "I":
        configDir = String(cString: optarg)
    default:
        print("""
            Usage:
                TODO
            """)
        exit(1)
    }
}

//Load config
let configName: String = "WhiteboardWrapper.config"
let configPaths: [String] = ["/home/carl/src/MiPal/GUNao/posix/gusimplewhiteboard"]
let config: Config
if let configM = Config(name: configName, paths: configPaths) {
    config = configM
}
else {
    config = Config()
    print("""
        Config Error:
            Could not locate a '\(configName)' in the paths specified.
            Creating a default version in the current directory.
            Please move it to the same directory as the .tsl file.
            Also, ensure that it is in the search paths.
        """)
    let newConfigPath: URL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let newConfigPathName: URL = newConfigPath.appendingPathComponent(configName)
    guard config.save(file: newConfigPathName) else {
        print("""
        IO Error:
            Could not save the file to: '\(newConfigPathName.path)'
        """)
        exit(1)
    }
    exit(1)
}

//if let tslNameFlag
    //overright config value.

dump(config)

exit(1)

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

