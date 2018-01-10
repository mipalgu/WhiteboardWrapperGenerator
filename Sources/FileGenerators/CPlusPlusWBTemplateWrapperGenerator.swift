/**                                                                     
 *  /file CPlusPlusWBTemplateWrapperGenerator.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */              
                                                        
import Foundation

import DataStructures
import Protocols
import NamingFuncs

final public class CPlusPlusWBTemplateWrapperGenerator: FileGenerator {

    public typealias T = TSL

    public var name: String
    public var path: URL

    public init(path: URL) {
        self.name = "guwhiteboardtypelist_generated.h"
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

#include \"gugenericwhiteboardobject.h\"

#pragma clang diagnostic push
#pragma clang diagnostic ignored \"-Wpadded\"

namespace guWhiteboard
{
extern \"C\"
{
#include \"guwhiteboardtypelist_c_generated.h\"
}

\(classes.map { entry in 
        let templateDataType = NamingFuncs.createCPlusPlusTemplateDataType(entry.type)
        let templateClassName = NamingFuncs.createCPlusPlusTemplateClassName(entry.name.string)
        let slotEnumName = NamingFuncs.createMsgEnumName(entry.name.string)
        let atomicString = entry.atomic.value ? "true" : "false"
        return """
            /** WB Ptr Class: \(templateClassName) @brief \(entry.comment.string) */ 
            class \(templateClassName): public generic_whiteboard_object<\(templateDataType) > { 
                public: 
                /** Constructor: \(templateClassName) */ 
                \(templateClassName)(gu_simple_whiteboard_descriptor *wbd = NULL): generic_whiteboard_object<\(templateDataType) >(wbd, \(slotEnumName), \(atomicString)) {}
                \(entry.type.isCustomTypeClass ? "" : """
                    /** Convenience constructor for non-class types. Pass a value and it'll be set in the Whiteboard: \(templateClassName) */ 
                    \(templateClassName)(\(templateDataType) value, gu_simple_whiteboard_descriptor *wbd = NULL): generic_whiteboard_object<\(templateDataType) >(value, \(slotEnumName), wbd, \(atomicString)) {} 
                    """)
            };


        """
        }.reduce("", +)
)
}

#pragma clang diagnostic pop

\(ifDefBottom)
"""
    }
}

