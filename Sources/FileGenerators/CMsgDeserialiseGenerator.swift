/**                                                                     
 *  /file CMsgDeserialiseGenerator.swift
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

final public class CMsgDeserialiseGenerator: FileGenerator {

    public typealias T = TSL

    public var name: String
    public var path: URL
    public var config: Config

    public init(path: URL, config: Config) {
        self.name = "guwhiteboarddeserialiser.c"
        self.path = path
        self.config = config
    }

    public func createContent(obj: T) -> String {
        let copyright = FileGeneratorHelpers.createCopyright(fileName: self.name)
        let (ifDefTop, ifDefBottom) = FileGeneratorHelpers.createIfDefWrapper(fileName: self.name, config: config) 
        let tsl: TSL = obj //alias
        let classes: [TSLEntry] = tsl.entries
        return """
\(copyright)

/** Auto-generated, don't modify! */

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-macros"
#pragma clang diagnostic ignored "-Wcast-qual"
#pragma clang diagnostic ignored "-Wshorten-64-to-32"
#pragma clang diagnostic ignored "-Wunreachable-code-break"

\(ifDefTop)

#define WHITEBOARD_DESERIALISER

#define DECOMPRESSION_CALL(...) _from_network_serialised(__VA_ARGS__);
#define DECOMPRESSION_FUNC_(s, p) s ## p
#define DECOMPRESSION_FUNC(s, p) DECOMPRESSION_FUNC_(s, p)
#define DESERIALISE(_struct, ...) DECOMPRESSION_FUNC(_struct, DECOMPRESSION_CALL(__VA_ARGS__))

#include \"guwhiteboardserialisation.h\"
#include \"guwhiteboard_c_types.h\"

int32_t deserialisemsg(\(WhiteboardHelpers().cNamespace(of: config.cNamespaces))_types message_index, const void *serialised_in, void *message_out)
{
    switch (message_index)
    {
\(classes.map { entry in 
        let isGenerated = NamingFuncs.createWasClassGeneratedFlag(entry.type, config: config)
        let cStructName = NamingFuncs.createClassGeneratorCStructFlag(entry.type, config: config)
        let slotEnumName = NamingFuncs.createMsgEnumNameNamespaced(entry.name.string, config: config)
        return """

            case \(slotEnumName):
            {
\(entry.type.isCustomTypeClass ? """
#if defined(\(isGenerated)) || defined(\(entry.type.typeName.uppercased())_GENERATED) // \(entry.type.typeName.uppercased())_GENERATED is legacy, don't use
#ifdef \(cStructName)
#define \(entry.type.typeName.uppercased())_C_STRUCT_NAME_COMPAT \(cStructName)
#else
#define \(entry.type.typeName.uppercased())_C_STRUCT_NAME_COMPAT \(entry.type.typeName.uppercased())_C_STRUCT
#endif
                return DESERIALISE(\(entry.type.typeName.uppercased())_C_STRUCT_NAME_COMPAT, serialised_in, (struct \(entry.type.typeName.uppercased())_C_STRUCT_NAME_COMPAT *)message_out)
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

