/**                                                                     
 *  /file ParserMessage.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */                                                                     

final public class ParserMessage {

    var message: String
    var location: String

    public init(msg: String, location: String) {
        self.message = msg
        self.location = location
    }

    public func toString() -> String {
        return location + ": " + message
    }
}

