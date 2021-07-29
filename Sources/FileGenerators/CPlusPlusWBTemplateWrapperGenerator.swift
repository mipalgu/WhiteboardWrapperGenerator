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
import whiteboard_helpers

final public class CPlusPlusWBTemplateWrapperGenerator: FileGenerator {

    public typealias T = TSL

    public var name: String
    public var path: URL
    public var config: Config

    public init(path: URL, config: Config) {
        self.name = "guwhiteboardtypelist_generated.h"
        self.path = path
        self.config = config
    }

    public func createContent(obj: T) -> String {
        let copyright = FileGeneratorHelpers.createCopyright(fileName: self.name)
        let (ifDefTop, ifDefBottom) = FileGeneratorHelpers.createIfDefWrapper(fileName: self.name, config: config) 
        let tsl: TSL = obj //alias
        let classes: [TSLEntry] = tsl.entries
        let wbNamePrefix = self.config.defaultWhiteboardName + "_"
        return """
\(copyright)

\(ifDefTop)

#include \"\(wbNamePrefix)gugenericwhiteboardobject.h\"

#pragma clang diagnostic push
#pragma clang diagnostic ignored \"-Wpadded\"
#pragma clang diagnostic ignored \"-Wc++98-compat\"

#undef CPP_WHITEBOARD_NAMESPACE
#define CPP_WHITEBOARD_NAMESPACE \(WhiteboardHelpers().cppNamespace(of: config.cppNamespaces))

extern \"C\"
{
#include \"guwhiteboardtypelist_c_generated.h\"
}

\(config.cppNamespaces.map({ "namespace " + $0 + " {\n" }).joined(separator: ""))

typedef ::\(WhiteboardHelpers().cNamespace(of: config.cNamespaces))_types \(WhiteboardHelpers().cNamespace(of: config.cNamespaces))_types;

typedef \(WhiteboardHelpers().cNamespace(of: config.cNamespaces))_types WBTypes;


\(classes.map { entry in 
        let templateDataType = NamingFuncs.createCPlusPlusTemplateDataType(entry.type, config: config)
        let templateClassName = NamingFuncs.createCPlusPlusTemplateClassName(entry.name.string, config: config)
        let slotEnumName = NamingFuncs.createMsgEnumNameNamespaced(entry.name.string, config: config)
        let atomicString = entry.atomic.value ? "true" : "false"
        let cns = WhiteboardHelpers().cNamespace(of: config.cNamespaces)
        return """
            /** WB Ptr Class: \(templateClassName) @brief \(entry.comment.string) */ 
            class \(templateClassName): public  \(cns)_generic_whiteboard_object<\(templateDataType) > {
                public: 
                /** Constructor: \(templateClassName) */ 
                \(templateClassName)(gu_simple_whiteboard_descriptor *wbd = NULLPTR): \(cns)_generic_whiteboard_object<\(templateDataType) >(wbd, \(slotEnumName), \(atomicString)) {}
                \(entry.type.isCustomTypeClass ? "" : """
                    /** Convenience constructor for non-class types. Pass a value and it'll be set in the Whiteboard: \(templateClassName) */ 
                    \(templateClassName)(\(templateDataType) value, gu_simple_whiteboard_descriptor *wbd = NULLPTR): \(cns)_generic_whiteboard_object<\(templateDataType) >(value, \(slotEnumName), wbd, \(atomicString)) {}
                    """)

                static const \(WhiteboardHelpers().cNamespace(of: config.cNamespaces))_types slot = \(slotEnumName);

                u_int16_t eventCounter() const {
                    return _wbd->wb->event_counters[\(templateClassName)::slot];
                }
            };


        """
        }.reduce("", +)
)

\(config.cppNamespaces.reversed().map({ "} // " + $0 + "\n" }).joined(separator: ""))

#pragma clang diagnostic pop

\(ifDefBottom)

"""
    }
}

