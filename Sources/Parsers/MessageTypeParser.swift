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

    public static func parse(valueString: String, config: Config) -> ParserObjectContainer<MessageType> {

        let ret = ParserObjectContainer<MessageType>()

        if valueString.isEmpty {
            return ret.error(msg: "The datatype flag is empty")
        }

        let type: MessageType = MessageType()

        //class:type
        if valueString.starts(with: "class:") {
            //legacy warning
            ret.addWarning(msg: "Using legacy type naming. For custom classes please use 'type:' and the name of your '.gen' file. Example: 'foo.gen' -> 'type:foo'. You can keep using this format but it could result in some edge case file name generatoring errors. I suggest switching :)")
            let className: String = String(valueString.dropFirst("class:".count))
            if className.isEmpty {
                return ret.error(msg: "No class name found.")
            }

            type.isLegacyCPlusPlusClassNaming = true
            type.isCustomTypeClass = true
            type.typeName = className
        }
        //type:type
        else if valueString.starts(with: "type:") {
            let genName: String = String(valueString.dropFirst("type:".count))
            if genName.isEmpty {
                return ret.error(msg: "No type name found.")
            }

            type.isLegacyCPlusPlusClassNaming = false
            type.isCustomTypeClass = true
            type.typeName = genName
        }
        //type          
        else {
            if !config.acceptableTypes.types.contains(valueString) {
                return ret.error(msg: "Whiteboard messages of type: '\(valueString)' have not been allowed in the configuration file.")
            }

            type.isLegacyCPlusPlusClassNaming = false
            type.isCustomTypeClass = false
            type.typeName = valueString
        }

        ret.set(object: type)
        return ret
    }
}

