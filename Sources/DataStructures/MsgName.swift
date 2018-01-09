/**                                                                     
 *  /file MsgName.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */                                                                     

import Protocols

final public class MsgName: HasInit {

    public var string: String

    public init(string: String) {
        self.string = string
    }

    public init() {
        self.string = ""
    }
}

