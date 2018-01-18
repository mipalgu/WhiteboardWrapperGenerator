/**                                                                     
 *  /file ConfigFile.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */                                                                     

import Protocols
import whiteboard_helpers

final public class Config: ConfigFile {

    public var tslName: String
    public var defaultWhiteboardName: String
    public var acceptableTypes: AcceptableTypes

    public init() {
        //default values
        self.tslName = "guwhiteboardtypelist.tsl"
        self.defaultWhiteboardName = "guWhiteboard"
        self.acceptableTypes = AcceptableTypes()
    }
}

