/**                                                                     
 *  /file AtomicFlagParser.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */                                                                     

import Foundation

import ParserFuncs
import DataStructures

final public class AtomicFlagParser {

    public static func parse(valueString: String) -> ParserObjectContainer<AtomicFlag> {

        let ret = ParserObjectContainer<AtomicFlag>()

        if valueString.isEmpty {
            return ret.error(msg: "The atomicity flag is empty")
        }

        let atomic: AtomicFlag = AtomicFlag()

        switch valueString {
            case "atomic":
                atomic.value = true
            case "nonatomic":
                atomic.value = false
            default:
                return ret.error(msg: "'\(valueString)' is not a valid Atomicity flag. Valid values are 'atomic' or 'nonatomic'.")
        }

        ret.set(object: atomic)
        return ret
    }
}

