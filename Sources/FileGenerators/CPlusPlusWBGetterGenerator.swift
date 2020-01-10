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

final public class CPlusPlusWBGetterGenerator: FileGenerator {

    public typealias T = TSL

    public var name: String
    public var path: URL

    public init(path: URL) {
        self.name = "guwhiteboardgetter.cpp"
        self.path = path
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
        let headerName = (obj.useCustomNamespace ? obj.wbNamespace + "_" + self.name : self.name)
        let copyright = FileGeneratorHelpers.createCopyright(fileName: headerName)
        let tsl: TSL = obj //alias
        let classes: [TSLEntry] = tsl.entries
        return """
\(copyright)

/** Auto-generated, don't modify! */

#include <string>
#include <vector>
#include <cstdlib>
#include <gu_util.h>

#define WHITEBOARD_POSTER_STRING_CONVERSION

#include \"guwhiteboardtypelist_generated.h\"
#include \"guwhiteboardgetter.h\"

using namespace std;
using namespace guWhiteboard;

#pragma clang diagnostic push
#pragma clang diagnostic ignored \"-Wunused-parameter\"
extern \"C\"
{
      char *\(obj.useCustomNamespace ? obj.wbNamespace
      + "_" : "")whiteboard_get(const char *message_type, gu_simple_message *msg)
    {
      return \(obj.useCustomNamespace ? obj.wbNamespace + "_" : "")whiteboard_getmsg(\(obj.useCustomNamespace ? "guWhiteboard::" + obj.wbNamespace + "::" + obj.wbNamespace + "_" : "")types_map[message_type], msg);
    }

      char *\(obj.useCustomNamespace ? obj.wbNamespace + "_" : "")whiteboard_get_from(gu_simple_whiteboard_descriptor *wbd, const char *message_type)
    {
      return \(obj.useCustomNamespace ? obj.wbNamespace + "_" : "")whiteboard_getmsg_from(wbd, \(obj.useCustomNamespace ? "guWhiteboard::" + obj.wbNamespace + "::" + obj.wbNamespace + "_" : "")types_map[message_type]);
    }

      char *\(obj.useCustomNamespace ? obj.wbNamespace + "_" : "")whiteboard_getmsg(int message_index, gu_simple_message *msg)
    {
      return gu_strdup(getmsg(\(obj.useCustomNamespace ? obj.wbNamespace + "::" + obj.wbNamespace + "_" : "")WBTypes(message_index), msg).c_str());
    }

      char *\(obj.useCustomNamespace ? obj.wbNamespace + "_" : "")whiteboard_getmsg_from(gu_simple_whiteboard_descriptor *wbd, int message_index)
    {
      return gu_strdup(getmsg(\(obj.useCustomNamespace ? obj.wbNamespace + "::" + obj.wbNamespace + "_" : "")WBTypes(message_index), NULLPTR, wbd).c_str());
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
namespace guWhiteboard
{\(obj.useCustomNamespace ? "\nnamespace " + obj.wbNamespace + "\n{" : "")
    string getmsg(string message_type, gu_simple_message *msg, gu_simple_whiteboard_descriptor *wbd)
    {
      return getmsg(\(obj.useCustomNamespace ? obj.wbNamespace + "::" + obj.wbNamespace + "_" : "")types_map[message_type], msg, wbd);
    }

      string getmsg(\(obj.useCustomNamespace ? obj.wbNamespace + "::" + obj.wbNamespace + "_" : "")WBTypes message_index, gu_simple_message *msg, gu_simple_whiteboard_descriptor *wbd)
    {
        switch (message_index)
        {
\(classes.map { entry in 
        let CPlusPlusClassName = NamingFuncs.createCPlusPlusClassName(entry.type)
        let WBPtrClass = NamingFuncs.createCPlusPlusTemplateClassName(entry.name.string)
        let slotEnumName = NamingFuncs.createMsgEnumName(entry.name.string)
        let get_fromStringConverted: String = createToString(type: entry.type, inputVarName: "m.get_from(msg)")
        let getStringConverted: String = createToString(type: entry.type, inputVarName: "m.get()")
        return """

      case \(obj.useCustomNamespace ? obj.wbNamespace + "::" + obj.wbNamespace + "_" : "")\(slotEnumName):
            {
\(entry.type.isCustomTypeClass ? "#ifdef  \(obj.useCustomNamespace ? obj.wbNamespace + "_" : "")\(CPlusPlusClassName)_DEFINED" : "")
          class \(obj.useCustomNamespace ? obj.wbNamespace + "::" : "")\(WBPtrClass) m(wbd);
                return msg ? \(get_fromStringConverted) : \(getStringConverted);
\(entry.type.isCustomTypeClass ? """
#else
                return \"##unsupported##\";
#endif //\(CPlusPlusClassName)_DEFINED
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
\(obj.useCustomNamespace ? "}\n" : "")}

"""
    }
}

