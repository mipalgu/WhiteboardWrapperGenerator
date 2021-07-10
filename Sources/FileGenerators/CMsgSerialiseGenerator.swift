/**                                                                     
 *  /file CMsgSerialiseGenerator.swift
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

final public class CMsgSerialiseGenerator: FileGenerator {

    public typealias T = TSL

    public var name: String
    public var path: URL
    public var config: Config

    public init(path: URL, config: Config) {
        self.name = "guwhiteboardserialiser.c"
        self.path = path
        self.config = config
    }

    public func createContent(obj: T) -> String {
        let copyright = FileGeneratorHelpers.createCopyright(fileName: self.name)
        let (ifDefTop, ifDefBottom) = FileGeneratorHelpers.createIfDefWrapper(fileName: self.name, config: config) 
        let tsl: TSL = obj //alias
        let classes: [TSLEntry] = tsl.entries
        let cns = WhiteboardHelpers().cNamespace(of: config.cNamespaces)
        return """
\(copyright)

/** Auto-generated, don't modify! */

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-macros"
#pragma clang diagnostic ignored "-Wcast-qual"
#pragma clang diagnostic ignored "-Wshorten-64-to-32"
#pragma clang diagnostic ignored "-Wunreachable-code-break"

\(ifDefTop)


#define WHITEBOARD_SERIALISER

#define COMPRESSION_CALL(...) _to_network_serialised(__VA_ARGS__);
#define COMPRESSION_FUNC_(s, p) s ## p
#define COMPRESSION_FUNC(s, p) COMPRESSION_FUNC_(s, p)
#define SERIALISE(_struct, ...) COMPRESSION_FUNC(_struct, COMPRESSION_CALL(__VA_ARGS__))

#include \"guwhiteboardserialisation.h\"
#include \"guwhiteboard_c_types.h\"

int32_t serialisemsg(\(cns)_types message_index, const void *message_in, void *serialised_out)
{
    switch (message_index)
    {
\(classes.map { entry in 
        let isGenerated = NamingFuncs.createWasClassGeneratedFlag(entry.type, config: config)
        let cStructName = NamingFuncs.createClassGeneratorCStructFlag(entry.type, config: config)
        let slotEnumName = NamingFuncs.createMsgEnumName(entry.name.string, config: config)
        return """

            case \(slotEnumName):
            {
\(entry.type.isCustomTypeClass ? """
#if defined(\(isGenerated))  || defined(\(entry.type.typeName.uppercased())_GENERATED) // \(entry.type.typeName.uppercased())_GENERATED is legacy, don't use
#ifdef \(cStructName)
#define \(entry.type.typeName.uppercased())_C_STRUCT_NAME_COMPAT \(cStructName)
#else
#define \(entry.type.typeName.uppercased())_C_STRUCT_NAME_COMPAT \(entry.type.typeName.uppercased())_C_STRUCT
#endif
                return SERIALISE(\(entry.type.typeName.uppercased())_C_STRUCT_NAME_COMPAT, (struct \(entry.type.typeName.uppercased())_C_STRUCT_NAME_COMPAT *)message_in, serialised_out)
#undef \(entry.type.typeName.uppercased())_C_STRUCT_NAME_COMPAT
#else
                return -1;
#endif //\(isGenerated)
""" : """
                return -1; /*TODO, add support for POD types.*/
""")
                break;
            }
"""
        }.reduce("", +)
)
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored \"-Wunreachable-code\"
    /*(void) message_content;*/
    return -1;
#pragma clang diagnostic pop
}

\(ifDefBottom)

#pragma clang diagnostic pop

"""
    }
}

