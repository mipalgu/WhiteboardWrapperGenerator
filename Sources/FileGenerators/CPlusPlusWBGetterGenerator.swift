/**                                                                     
 *  /file CPlusPlusWBGetterGenerator.swift
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

final public class CPlusPlusWBGetterGenerator: FileGenerator {

    public typealias T = TSL

    public var name: String
    public var path: URL
    public var config: Config

    public init(path: URL, config: Config) {
        self.name = "guwhiteboardgetter.cpp"
        self.path = path
        self.config = config
    }

    func createToString(type: MessageType, inputVarName: String) -> String {
        if type.isCustomTypeClass {
            return inputVarName.appending(".description()")
        }
        switch(type.typeName) {
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
                return "gu_ltos(long(\(inputVarName)))"
            case    "float",
                   "double":
                return "gu_dtos(\(inputVarName))"
            case "std::string":
                return "\(inputVarName)"
            case "std::vector<int>":
                return "intvectostring(\(inputVarName))"
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
#include <sstream>
#include <vector>
#include <cstdlib>
#include <gu_util.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored \"-Wunused-macros\"
#define WHITEBOARD_POSTER_STRING_CONVERSION
#pragma clang diagnostic pop

#include \"guwhiteboardtypelist_generated.h\"
#include \"guwhiteboardgetter.h\"

using namespace std;
using namespace \(WhiteboardHelpers().cppNamespace(of: config.cppNamespaces));


#pragma clang diagnostic push
#pragma clang diagnostic ignored \"-Wunused-parameter\"
extern \"C\"
{
    char *whiteboard_get(const char *message_type, gu_simple_message *msg)
    {
        return whiteboard_getmsg(types_map[message_type], msg);
    }

    char *whiteboard_get_from(gu_simple_whiteboard_descriptor *wbd, const char *message_type)
    {
        return whiteboard_getmsg_from(wbd, types_map[message_type]);
    }

    char *whiteboard_getmsg(int message_index, gu_simple_message *msg)
    {
        return gu_strdup(getmsg(\(WhiteboardHelpers().cNamespace(of: config.cNamespaces))_types(message_index), msg).c_str());
    }

    char *whiteboard_getmsg_from(gu_simple_whiteboard_descriptor *wbd, int message_index)
    {
        return gu_strdup(getmsg(\(WhiteboardHelpers().cNamespace(of: config.cNamespaces))_types(message_index), NULLPTR, wbd).c_str());
    }
} // extern C

#pragma clang diagnostic push
#pragma clang diagnostic ignored \"-Wunused-function\"
static string intvectostring(const vector<int> &vec)
{
    stringstream ss;
    
    for (vector<int>::const_iterator it = vec.begin(); it != vec.end(); it++)
    {
        if (it != vec.begin()) ss << \",\";
        ss << *it;
    }

    return ss.str();
}
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored \"-Wunused-parameter\"
#pragma clang diagnostic ignored \"-Wunreachable-code\"
\(config.cppNamespaces.map({ "namespace " + $0 + " {\n" }).joined(separator: ""))
    string getmsg(string message_type, gu_simple_message *msg, gu_simple_whiteboard_descriptor *wbd)
    {
        return getmsg(types_map[message_type], msg, wbd);
    }

    string getmsg(\(WhiteboardHelpers().cNamespace(of: config.cNamespaces))_types message_index, gu_simple_message *msg, gu_simple_whiteboard_descriptor *wbd)
    {
        switch (message_index)
        {
\(classes.map { entry in 
        let CPlusPlusClassName = NamingFuncs.createCPlusPlusClassName(entry.type, config: config)
        let WBPtrClass = NamingFuncs.createCPlusPlusTemplateClassName(entry.name.string, config: config)
        let slotEnumName = NamingFuncs.createMsgEnumNameNamespaced(entry.name.string, config: config)
        let get_fromStringConverted: String = createToString(type: entry.type, inputVarName: "m.get_from(msg)")
        let getStringConverted: String = createToString(type: entry.type, inputVarName: "m.get()")
        return """

            case \(slotEnumName):
            {
\(entry.type.isCustomTypeClass ? "#ifdef \(WhiteboardHelpers().cppDefinedDef(forClassNamed: CPlusPlusClassName, namespaces: config.cppNamespaces))" : "")
                class \(WBPtrClass) m(wbd);
                return msg ? \(get_fromStringConverted) : \(getStringConverted);
\(entry.type.isCustomTypeClass ? """
#else
                return \"##unsupported##\";
#endif //\(WhiteboardHelpers().cppDefinedDef(forClassNamed: CPlusPlusClassName, namespaces: config.cppNamespaces))
""" : "")
            }
"""
        }.reduce("", +)
)
        }
#pragma clang diagnostic push
#pragma clang diagnostic ignored \"-Wunreachable-code\"
        (void) msg;
        return \"##unsupported##\";
#pragma clang diagnostic pop
    }
#pragma clang diagnostic pop
#pragma clang diagnostic pop
\(config.cppNamespaces.reversed().map({ "} // " + $0 + "\n" }).joined(separator: ""))

"""
    }
}

