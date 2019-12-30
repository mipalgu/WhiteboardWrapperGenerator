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
        let headerName = (obj.useCustomNamespace ? obj.wbNamespace + "_" + self.name : self.name)
        let copyright = FileGeneratorHelpers.createCopyright(fileName: headerName)
        let (ifDefTop, ifDefBottom) = FileGeneratorHelpers.createIfDefWrapper(fileName: headerName) 
        let tsl: TSL = obj //alias
        let classes: [TSLEntry] = tsl.entries
        return """
\(copyright)

/** Auto-generated, don't modify! */

\(ifDefTop)

#include \"gugenericwhiteboardobject.h\"

#pragma clang diagnostic push
#pragma clang diagnostic ignored \"-Wpadded\"
#pragma clang diagnostic ignored \"-Wc++98-compat\"


namespace guWhiteboard
{\(obj.useCustomNamespace ? "\nnamespace " + obj.wbNamespace + "\n{" : "")
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
                \(templateClassName)(gu_simple_whiteboard_descriptor *wbd = NULLPTR): generic_whiteboard_object<\(templateDataType) >(wbd, \(obj.useCustomNamespace ? obj.wbNamespace + "_" : "")\(slotEnumName), \(atomicString)) {}
                \(entry.type.isCustomTypeClass ? "" : """
                    /** Convenience constructor for non-class types. Pass a value and it'll be set in the Whiteboard: \(templateClassName) */ 
                    \(templateClassName)(\(templateDataType) value, gu_simple_whiteboard_descriptor *wbd = NULLPTR): generic_whiteboard_object<\(templateDataType) >(value, \(obj.useCustomNamespace ? obj.wbNamespace + "_" : "")\(slotEnumName), wbd, \(atomicString)) {} 
                    """)
            };


        """
        }.reduce("", +)
)
\(obj.useCustomNamespace ? "}\n" : "")}

#pragma clang diagnostic pop

\(ifDefBottom)

"""
    }
}

