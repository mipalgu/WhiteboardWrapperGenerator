/**                                                                     
 *  /file MsgNameParser.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */                                                                     

import Foundation

import ParserFuncs
import DataStructures

final public class MsgNameParser {

    public static func parse(name: String) -> ParserObjectContainer<MsgName> {

        let ret = ParserObjectContainer<MsgName>()

        if name.isEmpty {
            return ret.error(msg: "The message name is empty.")
        }

        if let fc = name.first {
            if fc != String(fc).uppercased().first! {
                ret.addWarning(msg: "The first character of a message name should normally be capitalised.")
            }
        }

        if zip(name, name.dropFirst()).filter({ chars in
            let (c1, c2) = chars
            return c1 == "_" && c2 == String(c2).uppercased().first!
            }).count > 0 {
            ret.addWarning(msg: "Please use camal case for message names.")
            }

        ret.set(object: MsgName(string: name))
        return ret
    }
}

