/**                                                                     
 *  /file AtomicFlag.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */                                                                     

import Protocols

final public class AtomicFlag: HasInit {

    public var value: Bool 

    public init(value: Bool) {
        self.value = value 
    }

    public init() {
        self.value = false
    }
}

