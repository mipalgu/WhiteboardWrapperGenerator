/**                                                                     
 *  /file TypeEnumHeaderGenerator.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */              
                                                        
import Foundation

import DataStructures
import Protocols

final public class TypeEnumHeaderGenerator: FileGenerator {

    public typealias T = TSL

    public var name: String
    public var path: URL
    public var content: String

    public init(path: URL) {
        self.name = "guwhiteboardtypelist_c_generated.h"
        self.path = path
        self.content = ""
    }

    public func createContent(obj: T) -> String {
        return """
/**
 *  /file guwhiteboardtypelist_c_generated.h
 *
 *  Created by Carl Lusty in 2013.
 *  Copyright (c) 2013-2016 Carl Lusty and Rene Hexel
 *  All rights reserved.
 */


#ifndef GUWHITEBOARD_TYPELIST_C_H_
#define GUWHITEBOARD_TYPELIST_C_H_


#define WANT_WB_STRINGS

#include \"gusimplewhiteboard.h\" //GSW_NUM_RESERVED

#define GSW_NUM_TYPES_DEFINED 113
"""
    }
}

