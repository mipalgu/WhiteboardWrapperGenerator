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
        let headerName = (obj.useCustomNamespace ? obj.wbNamespace + "_" + self.name : self.name)
        let copyright = FileGeneratorHelpers.createCopyright(fileName: headerName)
        let (ifDefTop, ifDefBottom) = FileGeneratorHelpers.createIfDefWrapper(fileName: headerName) 
        let tsl: TSL = obj //alias
        let classes: [TSLEntry] = tsl.entries
        return """
\(copyright)

/** Auto-generated, don't modify! */

\(ifDefTop)

#include \"gusimplewhiteboard.h\"
#include \"guwhiteboardtypelist_c_generated.h\"

      const char *\(obj.useCustomNamespace ? obj.wbNamespace
      + "_" : "")WBTypes_stringValues[\(obj.useCustomNamespace ? obj.wbNamespace.uppercased()
      + "_" : "")GSW_NUM_TYPES_DEFINED] =
{
\(classes.map { entry in 
        return """

        \"\(entry.name.string)\",
"""
        }.reduce("", +).dropLast()
)
};

      const char *\(obj.useCustomNamespace ? obj.wbNamespace
      + "_" : "")WBTypes_typeValues[\(obj.useCustomNamespace ? obj.wbNamespace.uppercased()
      + "_" : "")GSW_NUM_TYPES_DEFINED] =
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

