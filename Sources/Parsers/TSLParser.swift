/**                                                                     
 *  /file TSLParser.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */                                                                     

import Foundation

import ParserFuncs
import DataStructures

final public class TSLParser {

    public static func parse(tslFilePath: URL) -> ParserObjectContainer<TSL> {

        let ret = ParserObjectContainer<TSL>(location: "\(tslFilePath.path)")

        let contentDM: Data? = try? Data(contentsOf: tslFilePath)
        let contentM: String? = contentDM.flatMap { 
                                String(data: $0, encoding: .utf8) 
                              }
        guard let content = contentM else {
            return ret.error(msg: "Could not read the file.")
        }
        if content.isEmpty {
            return ret.error(msg: "file is empty.")
        }

        ret.currentLocation = "\(tslFilePath.lastPathComponent)"

        let origLoc = ret.currentLocation
        for (i, line) in content.split(separator: "\n").enumerated() {
            let lineNum: Int = i + 1 //Text editor line numbers
            let entryContainer = TSLEntryParser.parse(inputLine: String(line))
            ret.currentLocation = origLoc + ":\(lineNum)"
            ret.concat(append: entryContainer, objAppend: {
                $0.entries.append($1)
                return $0
                })
            ret.currentLocation = origLoc
            if ret.hasError() {
                return ret
            }
        }

        return ret
    }
}

