/**                                                                     
 *  /file Namespace.swift
 *                                                                      
 *  Created by Carl Lusty in 2021.                                      
 *  Copyright (c) 2021 Carl Lusty                                       
 *  All rights reserved.                                                
 */                                                                     

import Protocols
import whiteboard_helpers

public struct Namespace: Codable {
    public var cNamespace: CNamespace? = nil
    public var cppNamespace: CPPNamespace? = nil
}

