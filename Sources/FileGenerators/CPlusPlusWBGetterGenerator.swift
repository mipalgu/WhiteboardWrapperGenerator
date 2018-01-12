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

    public func createContent(obj: T) -> String {
        let copyright = FileGeneratorHelpers.createCopyright(fileName: self.name)
        let (ifDefTop, ifDefBottom) = FileGeneratorHelpers.createIfDefWrapper(fileName: self.name) 
        let tsl: TSL = obj //alias
        let classes: [TSLEntry] = tsl.entries
        return """
\(copyright)

\(ifDefTop)

/** Auto-generated, don't modify! */

#include <string>
#include <vector>
#include <cstdlib>

#define WHITEBOARD_POSTER_STRING_CONVERSION

#include \"guwhiteboardtypelist_generated.h\"
#include \"guwhiteboardgetter.h\"

using namespace std;
using namespace guWhiteboard;

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
        return gu_strdup(getmsg(WBTypes(message_index), msg).c_str());
    }

    char *whiteboard_getmsg_from(gu_simple_whiteboard_descriptor *wbd, int message_index)
    {
        return gu_strdup(getmsg(WBTypes(message_index), NULL, wbd).c_str());
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
{
    string getmsg(string message_type, gu_simple_message *msg, gu_simple_whiteboard_descriptor *wbd)
    {
        return getmsg(types_map[message_type], msg, wbd);
    }

    string getmsg(WBTypes message_index, gu_simple_message *msg, gu_simple_whiteboard_descriptor *wbd)
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
                class \(WBPtrClass) m(wbd);
                return msg ? m.get_from(msg)\(entry.type.isCustomTypeClass ? ".description()":"") : m.get()\(entry.type.isCustomTypeClass ? ".description()":"");
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
}

\(ifDefBottom)
"""
    }
}

