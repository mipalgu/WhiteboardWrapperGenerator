/**                                                                     
 *  /file CommentParser.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */                                                                     

import Foundation

import ParserFuncs
import DataStructures

final public class CommentParser {

    public static func parse(valueString: String) -> ParserObjectContainer<MsgComment> {

        let ret = ParserObjectContainer<MsgComment>()

        if valueString.isEmpty {
            return ret.error(msg: "The comment field is empty.")
        }

        if valueString.count < 20 {
            ret.addWarning(msg: "That is a very short comment.")
        }

        let comment: MsgComment = MsgComment(string: valueString)
        ret.set(object: comment)
        return ret
    }
}

