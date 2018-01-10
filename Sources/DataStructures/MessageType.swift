/**                                                                     
 *  /file MessageType.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */                                                                     

import Protocols

final public class MessageType: HasInit {
    public var isLegacyCPlusPlusClassNaming: Bool
    public var isCustomTypeClass: Bool
    public var typeName: String

    public init() {
        self.isLegacyCPlusPlusClassNaming = false
        self.isCustomTypeClass = false
        self.typeName = ""
    }
}

