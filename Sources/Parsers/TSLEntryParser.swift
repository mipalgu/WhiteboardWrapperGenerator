/**                                                                     
 *  /file TSLEntryParser.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */                                                                     

import Foundation

import ParserFuncs
import DataStructures

final public class TSLEntryParser {

    public static func parse(inputLine: String) -> ParserObjectContainer<TSLEntry> {

        let ret = ParserObjectContainer<TSLEntry>()

        let commaSep = inputLine.split(separator: ",", omittingEmptySubsequences: false)
        if commaSep.count != 4 {
            //TMP
            //ret.addWarning(msg: "Entry has the wrong number of elements")
        }
        let elements: [String] = commaSep.map { String($0).trimmingCharacters(in: .whitespaces) }

        var currentChar: Int = 0
        //process msg type
        //--------------------------
        let typeContainer = MessageTypeParser.parse(valueString: String(elements[0]))
        ret.concat(append: typeContainer, objAppend: {
                $0.type = $1
                return $0
                })
        if ret.hasError() {
            return ret
        }
        //--------------------------
        currentChar += elements[0].count

        ret.currentLocation = ":\(currentChar)"
        //process atomic
        //--------------------------
        let atomicContainer = AtomicFlagParser.parse(valueString: String(elements[1]))
        ret.concat(append: atomicContainer, objAppend: {
                $0.atomic = $1
                return $0
                })
        if ret.hasError() {
            return ret
        }
        //--------------------------
        currentChar += elements[1].count

        ret.currentLocation = ":\(currentChar)"
        //process msg name
        //--------------------------
        let nameContainer = MsgNameParser.parse(name: String(elements[2]))
        ret.concat(append: nameContainer, objAppend: {
                $0.name = $1
                return $0
                })
        if ret.hasError() {
            return ret
        }
        //--------------------------
        currentChar += elements[2].count

        ret.currentLocation = ":\(currentChar)"
        //process comment
        //--------------------------
        let commentContainer = CommentParser.parse(valueString: String(elements[3]))
        ret.concat(append: commentContainer, objAppend: {
                $0.comment = $1
                return $0
                })
        if ret.hasError() {
            return ret
        }
        //--------------------------
        currentChar += elements[3].count
        
        return ret
    }
}

