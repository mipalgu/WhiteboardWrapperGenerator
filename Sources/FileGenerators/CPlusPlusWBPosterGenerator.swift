/**                                                                     
 *  /file CPlusPlusWBPosterGenerator.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */              
                                                        
import Foundation

import DataStructures
import Protocols
import NamingFuncs

final public class CPlusPlusWBPosterGenerator: FileGenerator {

    public typealias T = TSL

    public var name: String
    public var path: URL

    public init(path: URL) {
        self.name = "guwhiteboardposter.cpp"
        self.path = path
    }

    func createParserForPrimitives(type: String, inputVarName: String) -> String {
        switch(type) {
            case      "int",
                     "bool",
                  "uint8_t", 
                   "int8_t", 
                 "uint16_t", 
                  "int16_t", 
                 "uint32_t", 
                  "int32_t",
                 "uint64_t", 
                  "int64_t":
                return "static_cast<\(type)>(atoi(\(inputVarName).c_str()))"
            case    "float",
                   "double":
                return "static_cast<\(type)>(atof(\(inputVarName).c_str()))"
            case "std::string":
                return "\(inputVarName)"
            case "std::vector<int>":
                return "strtointvec(\(inputVarName))"
            default:
                return "\(inputVarName)"
        }
    }

    public func createContent(obj: T) -> String {
        let copyright = FileGeneratorHelpers.createCopyright(fileName: self.name)
        let tsl: TSL = obj //alias
        let classes: [TSLEntry] = tsl.entries
        return """
\(copyright)

/** Auto-generated, don't modify! */

#include <string>
#include <vector>
#include <cstdlib>

#define WHITEBOARD_POSTER_STRING_CONVERSION

#include \"guwhiteboardtypelist_generated.h\"
#include \"guwhiteboardposter.h\"

using namespace std;
using namespace guWhiteboard;

extern \"C\"
{
    WBTypes whiteboard_type_for_message_named(const char *message_type)
    {
        return types_map[message_type];
    }

    bool whiteboard_post(const char *message_type, const char *message_content)
    {
        return whiteboard_postmsg(types_map[message_type], message_content);
    }

    bool whiteboard_post_to(gu_simple_whiteboard_descriptor *wbd, const char *message_type, const char *message_content)
    {
        return whiteboard_postmsg_to(wbd, types_map[message_type], message_content);
    }

    bool whiteboard_postmsg(int message_index, const char *message_content)
    {
        return postmsg(WBTypes(message_index), message_content);
    }

    bool whiteboard_postmsg_to(gu_simple_whiteboard_descriptor *wbd, int message_index, const char *message_content)
    {
        return postmsg(WBTypes(message_index), message_content, wbd);
    }
} // extern C

#pragma clang diagnostic push
#pragma clang diagnostic ignored \"-Wunused-function\"

static vector<int> strtointvec(string str)
{
    const char *sep = "|,";
    char *context = NULLPTR;
    vector<int> array;
    for (char *element = strtok_r(const_cast<char *>(str.c_str()), sep, &context); element; element = strtok_r(NULLPTR, sep, &context))
        array.push_back(atoi(element));
    return array;
}

#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored \"-Wglobal-constructors\"
#pragma clang diagnostic ignored \"-Wexit-time-destructors\"

whiteboard_types_map guWhiteboard::types_map; ///< global types map

#pragma clang diagnostic pop

namespace guWhiteboard
{
    bool post(string message_type, string message_content, gu_simple_whiteboard_descriptor *wbd)
    {
        return postmsg(types_map[message_type], message_content, wbd);
    }


    bool postmsg(WBTypes message_index, std::string message_content, gu_simple_whiteboard_descriptor *wbd)
    {
        switch (message_index)
        {
\(classes.map { entry in 
        let CPlusPlusClassName = NamingFuncs.createCPlusPlusClassName(entry.type)
        let WBPtrClass = NamingFuncs.createCPlusPlusTemplateClassName(entry.name.string)
        let slotEnumName = NamingFuncs.createMsgEnumName(entry.name.string)
        return """

        case \(slotEnumName):
        {
        \(entry.type.isCustomTypeClass ? "#ifdef \(CPlusPlusClassName)_DEFINED" : "")
            class \(WBPtrClass) msg_ptr(wbd);
            \(entry.type.isCustomTypeClass ? """
                \(CPlusPlusClassName) v = msg_ptr.get();
                v.from_string(message_content);
                """ : """
                \(entry.type.typeName) v = \(createParserForPrimitives(type: entry.type.typeName, inputVarName: "message_content"));
                """)
            msg_ptr.post(v);
            return true;
        \(entry.type.isCustomTypeClass ? """
            #else
                return false;
            #endif //\(CPlusPlusClassName)_DEFINED
            """ : "")
        }
        """
        }.reduce("", +)
)

#pragma clang diagnostic push
#pragma clang diagnostic ignored \"-Wunreachable-code\"
        (void) message_content;
    }

    return false;
#pragma clang diagnostic pop
    }
}

whiteboard_types_map::whiteboard_types_map(): map<string, WBTypes>()
{
    whiteboard_types_map &self = *this;

\(classes.map { entry in 
        let slotEnumName = NamingFuncs.createMsgEnumName(entry.name.string)
        return """
            self[\"\(entry.name.string)\"] = \(slotEnumName);

        """
        }.reduce("", +)
)
    (void) self;
}

"""
    }
}

