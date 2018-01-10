/**                                                                     
 *  /file Template.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */              
                                                        
import Foundation

import DataStructures
import Protocols
import NamingFuncs

final public class Template: FileGenerator {

    public typealias T = TSL

    public var name: String
    public var path: URL

    public init(path: URL) {
        self.name = "Template.h"
        self.path = path
    }

    public func createContent(obj: T) -> String {
        let copyright = FileGeneratorHelpers.createCopyright(fileName: self.name)
        let (ifDefTop, ifDefBottom) = FileGeneratorHelpers.createIfDefWrapper(fileName: self.name) 
        let tsl: TSL = obj //alias
        return """
\(copyright)

\(ifDefTop)


\(ifDefBottom)
"""
    }
}

