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
import whiteboard_helpers

final public class CTypeStringLookupGenerator: FileGenerator {

    public typealias T = TSL

    public var name: String
    public var path: URL
    public var config: Config

    public init(path: URL, config: Config) {
        self.name = "guwhiteboardtypelist_c_typestrings_generated.c"
        self.path = path
        self.config = config
    }

    public func createContent(obj: T) -> String {
        let copyright = FileGeneratorHelpers.createCopyright(fileName: self.name)
        let (ifDefTop, ifDefBottom) = FileGeneratorHelpers.createIfDefWrapper(fileName: self.name, config: config) 
        let tsl: TSL = obj //alias
        let classes: [TSLEntry] = tsl.entries
        let ntd = WhiteboardHelpers().createDefName(forClassNamed: "NUM_TYPES_DEFINED", namespaces: config.cNamespaces)
        return """
\(copyright)

/** Auto-generated, don't modify! */

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-macros"

        \(ifDefTop)

#include \"gusimplewhiteboard.h\"
#include \"guwhiteboardtypelist_c_generated.h\"

//Hack for WBTypes_stringValues extern
#ifndef BUILD_WB_LIBRARY
int num_types_defined = \(ntd);
const char **WBTypes_stringValues = \(WhiteboardHelpers().cNamespace(of: config.cNamespaces))_types_stringValues;
#endif

const char *\(WhiteboardHelpers().cNamespace(of: config.cNamespaces))_types_stringValues[\(ntd)] = 
{
\(classes.map { entry in 
        return """

        \"\(entry.name.string)\",
"""
        }.reduce("", +).dropLast()
)
};

const char *\(WhiteboardHelpers().cNamespace(of: config.cNamespaces))_types_typeValues[\(ntd)] = 
{
\(classes.map { entry in 
        return """

        \"\(NamingFuncs.createCStructName(entry.type, config: config))\",
"""
        }.reduce("", +).dropLast()
)
};

\(ifDefBottom)

#pragma clang diagnostic pop

"""
    }
}

