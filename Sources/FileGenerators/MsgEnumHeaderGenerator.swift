/**                                                                     
 *  /file MsgEnumHeaderGenerator.swift
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

final public class MsgEnumHeaderGenerator: FileGenerator {

    public typealias T = TSL

    public var name: String
    public var path: URL
    public var config: Config

    public init(path: URL, config: Config) {
        self.name = "guwhiteboardtypelist_c_generated.h"
        self.path = path
        self.config = config
    }

    public func createContent(obj: T) -> String {
        let copyright = FileGeneratorHelpers.createCopyright(fileName: self.name)
        let (ifDefTop, ifDefBottom) = FileGeneratorHelpers.createIfDefWrapper(fileName: self.name, config: config) 
        let tsl: TSL = obj //alias
        let ntd = WhiteboardHelpers().createDefName(forClassNamed: "NUM_TYPES_DEFINED", namespaces: config.cNamespaces)
        return """
\(copyright)

\(ifDefTop)

#undef WANT_WB_STRINGS
#define WANT_WB_STRINGS

#include \"gusimplewhiteboard.h\" //GSW_NUM_RESERVED

#define \(ntd) \(tsl.entries.count)

#define C_WHITEBOARD_NAMESPACE \(WhiteboardHelpers().cNamespace(of: config.cNamespaces))

#if \(ntd) > GSW_NUM_RESERVED
#error *** Error: gusimplewhiteboard: The number of defined types exceeds the total number of reserved types allowed. Increase GSW_NUM_RESERVED to solve this.
#endif

/** All the message 'types' for the class based whiteboard */
typedef enum \(WhiteboardHelpers().cNamespace(of: config.cNamespaces))_types
{
\(tsl.entries.dropLast().enumerated().map { elm in 
        let (i, e) = elm
        return "    \(NamingFuncs.createMsgEnumNameNamespaced(e.name.string, config: config)) = \(i), \t\t///< \(e.comment.string)\n"
        }.reduce("", +)
)
\(tsl.entries.suffix(1).enumerated().map { elm in 
        let (i, e) = elm
        return "    \(NamingFuncs.createMsgEnumName(e.name.string, config: config)) = \(i + tsl.entries.dropLast().count) \t\t///< \(e.comment.string)\n"
        }.reduce("", +)
)

} \(WhiteboardHelpers().cNamespace(of: config.cNamespaces))_types; ///< All the message 'types' for the class based whiteboard 
#ifndef WBTypes_DEFINED
#define WBTypes_DEFINED
typedef \(WhiteboardHelpers().cNamespace(of: config.cNamespaces))_types WBTypes;
#endif

\(tsl.entries.enumerated().map { elm in
        let (_, e) = elm
        return "#define \(NamingFuncs.createMsgEnumName(e.name.string, config: config)) \(NamingFuncs.createMsgEnumNameNamespaced(e.name.string, config: config))\n"
        }.reduce("", +)
)

extern const char *\(WhiteboardHelpers().cNamespace(of: config.cNamespaces))_types_stringValues[\(ntd)];
extern const char *\(WhiteboardHelpers().cNamespace(of: config.cNamespaces))_types_typeValues[\(ntd)];

\(ifDefBottom)

"""
    }
}

