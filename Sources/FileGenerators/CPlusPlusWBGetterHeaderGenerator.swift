/**                                                                     
 *  /file CPlusPlusWBGetterHeaderGenerator.swift
 *                                                                      
 *  Created by Carl Lusty in 2021.                                      
 *  Copyright (c) 2021 Carl Lusty                                       
 *  All rights reserved.                                                
 */              
                                                        
import Foundation

import DataStructures
import Protocols
import NamingFuncs
import whiteboard_helpers

final public class CPlusPlusWBGetterHeaderGenerator: FileGenerator {

    public typealias T = TSL

    public var name: String
    public var path: URL
    public var config: Config

    public init(path: URL, config: Config) {
        self.name = "guwhiteboardgetter.h"
        self.path = path
        self.config = config
    }

    public func createContent(obj: T) -> String {
        let copyright = FileGeneratorHelpers.createCopyright(fileName: self.name)
        let (ifDefTop, ifDefBottom) = FileGeneratorHelpers.createIfDefWrapper(fileName: self.name, config: config) 
        let cns = WhiteboardHelpers().cNamespace(of: config.cNamespaces)
        let cppns = WhiteboardHelpers().cppNamespace(of: config.cppNamespaces)
        return """
\(copyright)

\(ifDefTop)

/** Auto-generated, don't modify! */

#include "guwhiteboardposter.h"

#ifdef __cplusplus
extern "C"
{
#endif

/**
 * A generic C function that gets a message from the whiteboard.
 * Both the message type and the message content are strings.
 * The returned message string has to be freed!
 */
char *whiteboard_get(const char *message_type, gu_simple_message *msg);

/**
 * A generic C function that gets a message from the given whiteboard.
 * Both the message type and the message content are strings.
 * The returned message string has to be freed!
 */
char *whiteboard_get_from(gu_simple_whiteboard_descriptor *wbd, const char *message_type);

/**
 * Generic C function that gets a message with a given message number
 * from the whiteboard.
 * The returned message string has to be freed!
 */
char *whiteboard_getmsg(int message_index, gu_simple_message *msg);

/**
 * Generic C function that gets a message with a given message number
 * from the given whiteboard.
 * The returned message string has to be freed!
 */
char *whiteboard_getmsg_from(gu_simple_whiteboard_descriptor *wbd, int message_index);

#ifdef __cplusplus
} // extern "C"

\(config.cppNamespaces.map({ "namespace " + $0 + " {\n" }).joined(separator: ""))
        /**
         * A generic C++ function that gets a string from the whiteboard.
         * Both the message type and the message content are strings.
         * @param message_type the string version of the type
         * @param msg the data container, if NULLPTR then the message is gotten from the whiteboard
         * @param wbd the whiteboard to get the message from (NULLPTR for the default whiteboard) - this parameter has no effect if `msg` is non-NULLPTR
         * @return the pretty printed data string
         */
        std::string getmsg(std::string message_type, gu_simple_message *msg = NULLPTR, gu_simple_whiteboard_descriptor *wbd = NULLPTR);

        /**
         * Generic C++ function that gets a message with a given message number
         * to the whiteboard.
         * @param message_index the offset or enum value of the type to get
         * @param msg the data container, if NULLPTR then the message is gotten from the whiteboard
         * @param wbd the whiteboard to get the message from (NULLPTR for the default whiteboard) - this parameter has no effect if `msg` is non-NULLPTR
         * @return the pretty printed data string
         */
        std::string getmsg(\(cppns)::\(cns)_types message_index, gu_simple_message *msg = NULLPTR, gu_simple_whiteboard_descriptor *wbd = NULLPTR);

\(config.cppNamespaces.reversed().map({ "} // " + $0 + "\n" }).joined(separator: ""))
#endif // __cplusplus

\(ifDefBottom)

"""
    }
}
