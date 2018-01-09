/**                                                                     
 *  /file MessageTypeParser.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */                                                                     

import Foundation

import ParserFuncs
import DataStructures

final public class MessageTypeParser {

    public static func parse(valueString: String) -> ParserObjectContainer<MessageType> {

        let ret = ParserObjectContainer<MessageType>()

        if valueString.isEmpty {
            return ret.error(msg: "The datatype flag is empty")
        }

        let type: MessageType = MessageType()
/*

        switch valueString {
            case "atomic":
                atomic.value = true
            case "nonatomic":
                atomic.value = false
            default:
                return ret.error(msg: "'\(valueString)' is not a valid Atomicity flag. Valid values are 'atomic' or 'nonatomic'.")
        }
*/
        ret.set(object: type)
        return ret
    }
}

