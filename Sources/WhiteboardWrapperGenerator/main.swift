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

var configIncludePaths: [String] = []
var tslNameFlag: String?

while case let option = getopt(CommandLine.argc, CommandLine.unsafeArgv, "f:P:I:"), option != -1 {
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
        configIncludePaths.append(String(cString: optarg))
    case "I":
        configIncludePaths.append(String(cString: optarg))
    default:
        print("""
            Usage:
                -f: Force .tsl file name, overriding configs (legacy).
                -P: Add a path to look for config files in (legacy).
                -I: Add a path to look for config files in.
            """)
        exit(1)
    }
}

if configIncludePaths.isEmpty {
    configIncludePaths = ["../", "./", "../gusimplewhiteboard/"]
}

let configName: String = "WhiteboardWrapper.config"

//Load config
guard let configURL = Config.findConfig(name: configName, paths: configIncludePaths) else {
    print("""
        Config Error:
            Could not locate a '\(configName)' in the paths specified.
            Creating a default version in the current directory.
            Please move it to the same directory as the .tsl file.
            Also, ensure that it is in the search paths.
        """)
    let newConfigPath: URL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let newConfigPathName: URL = newConfigPath.appendingPathComponent(configName)
    guard Config().save(file: newConfigPathName) else {
        print("""
        IO Error:
            Could not save the file to: '\(newConfigPathName.path)'
        """)
        exit(1)
    }
    exit(1)
}

guard let config = Config(file: configURL) else {
    print("""
    Config Error:
        Could not load config from '\(configURL.path)'.
    """)
    exit(1)
}

//commandline config overrides
let tslName: String = tslNameFlag ?? config.tslName
let tslPath: URL = configURL.deletingLastPathComponent()
let tslURL: URL = tslPath.appendingPathComponent(tslName)

//parse tsl
let container = TSLParser.parse(tslFilePath: tslURL, config: config)

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
    let fileGenerator = FileGeneratorManager(tsl: tsl, wbPath: tslPath, config: config)
    fileGenerator.generate()
}

