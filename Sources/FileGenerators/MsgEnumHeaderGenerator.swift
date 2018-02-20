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

final public class MsgEnumHeaderGenerator: FileGenerator {

    public typealias T = TSL

    public var name: String
    public var path: URL

    public init(path: URL) {
        self.name = "guwhiteboardtypelist_c_generated.h"
        self.path = path
    }

    public func createContent(obj: T) -> String {
        let copyright = FileGeneratorHelpers.createCopyright(fileName: self.name)
        let (ifDefTop, ifDefBottom) = FileGeneratorHelpers.createIfDefWrapper(fileName: self.name) 
        let tsl: TSL = obj //alias
        return """
\(copyright)

\(ifDefTop)

#define WANT_WB_STRINGS

#include \"gusimplewhiteboard.h\" //GSW_NUM_RESERVED

#define GSW_NUM_TYPES_DEFINED \(tsl.entries.count)

#if GSW_NUM_TYPES_DEFINED > GSW_NUM_RESERVED
#error *** Error: gusimplewhiteboard: The number of defined types exceeds the total number of reserved types allowed. Increase GSW_NUM_RESERVED to solve this.
#endif

/** All the message 'types' for the class based whiteboard */
typedef enum wb_types
{
\(tsl.entries.dropLast().enumerated().map { elm in 
        let (i, e) = elm
        return "    \(NamingFuncs.createMsgEnumName(e.name.string)) = \(i), \t\t///< \(e.comment.string)\n"
        }.reduce("", +)
)
\(tsl.entries.suffix(1).enumerated().map { elm in 
        let (i, e) = elm
        return "    \(NamingFuncs.createMsgEnumName(e.name.string)) = \(i) \t\t///< \(e.comment.string)\n"
        }.reduce("", +)
)

} WBTypes; ///< All the message 'types' for the class based whiteboard 

extern const char *WBTypes_stringValues[GSW_NUM_TYPES_DEFINED];
extern const char *WBTypes_typeValues[GSW_NUM_TYPES_DEFINED];

\(ifDefBottom)

"""
    }
}

