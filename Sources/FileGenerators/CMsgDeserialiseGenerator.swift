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

final public class CMsgDeserialiseGenerator: FileGenerator {

    public typealias T = TSL

    public var name: String
    public var path: URL

    public init(path: URL) {
        self.name = "guwhiteboarddeserialiser.c"
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

/** Auto-generated, don't modify! */

#define WHITEBOARD_DESERIALISER

#define DECOMPRESSION_CALL(...) _from_network_serialised(__VA_ARGS__);
#define DECOMPRESSION_FUNC_(s, p) s ## p
#define DECOMPRESSION_FUNC(s, p) DECOMPRESSION_FUNC_(s, p)
#define DESERIALISE(_struct, ...) DECOMPRESSION_FUNC(_struct, DECOMPRESSION_CALL(__VA_ARGS__))

#include \"guwhiteboardserialisation.h\"
#include \"guwhiteboard_c_types.h\"

size_t deserialisemsg(WBTypes message_index, const void *serialised_in, void *message_out)
{
    switch (message_index)
    {
\(classes.map { entry in 
        let isGenerated = NamingFuncs.createWasClassGeneratedFlag(entry.type)
        let cStructName = NamingFuncs.createClassGeneratorCStructFlag(entry.type)
        let slotEnumName = NamingFuncs.createMsgEnumName(entry.name.string)
        return """

            case \(slotEnumName):
            {
\(entry.type.isCustomTypeClass ? """
#ifdef \(isGenerated)
                return DESERIALISE(\(cStructName), serialised_in, (struct \(cStructName) *)message_out)
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

"""
    }
}

