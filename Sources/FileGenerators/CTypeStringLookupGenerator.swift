/**                                                                     
 *  /file CTypeStringLookupGenerator.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */               
                                                       
import Foundation

import DataStructures
import Protocols
import NamingFuncs

final public class CTypeStringLookupGenerator: FileGenerator {

    public typealias T = TSL

    public var name: String
    public var path: URL

    public init(path: URL) {
        self.name = "guwhiteboardtypelist_c_typestrings_generated.c"
        self.path = path
    }

    public func createContent(obj: T) -> String {
        let copyright = FileGeneratorHelpers.createCopyright(fileName: self.name)
        let (ifDefTop, ifDefBottom) = FileGeneratorHelpers.createIfDefWrapper(fileName: self.name) 
        let tsl: TSL = obj //alias
        let classes: [TSLEntry] = tsl.entries
        return """
\(copyright)

\(ifDefTop)

#include \"gusimplewhiteboard.h\"
#include \"guwhiteboardtypelist_c_generated.h\"

const char *WBTypes_stringValues[GSW_NUM_TYPES_DEFINED] = 
{
\(classes.map { entry in 
        return """

        \"\(entry.name.string)\",
"""
        }.reduce("", +).dropLast()
)
};

const char *WBTypes_typeValues[GSW_NUM_TYPES_DEFINED] = 
{
\(classes.map { entry in 
        return """

        \"\(NamingFuncs.createCStructName(entry.type))\",
"""
        }.reduce("", +).dropLast()
)
};

\(ifDefBottom)

"""
    }
}

