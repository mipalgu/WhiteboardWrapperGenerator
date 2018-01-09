/**                                                                     
 *  /file MessageType.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */                                                                     

import Protocols

public enum SupportedPODTypes {
    case uint8_t
    case uint16_t
    case uint32_t
    case uint64_t
}

final public class MessageType: HasInit {
    public var isCustomTypeClass: Bool
    public var customClassName: String?
    public var podType: SupportedPODTypes?

    public init() {
        self.isCustomTypeClass = false
        self.customClassName = nil
        self.podType = nil
    }
}

