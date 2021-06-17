/**                                                                     
 *  /file CPlusPlusWBPosterHeaderGenerator.swift
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

final public class CPlusPlusWBPosterHeaderGenerator: FileGenerator {

    public typealias T = TSL

    public var name: String
    public var path: URL
    public var config: Config

    public init(path: URL, config: Config) {
        self.name = "guwhiteboardposter.h"
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


#ifdef __cplusplus
#include <string>
#include <map>
#include <stdbool.h>

extern "C"
{
#else
#include <stdbool.h>
#endif // __cplusplus

#include "gusimplewhiteboard.h"
#include "guwhiteboardtypelist_c_generated.h"

/**
 * A generic C function that posts to the whiteboard.
 * Both the message type and the message content are strings.
 */
bool whiteboard_post(const char *message_type, const char *message_content);

/**
 * A generic C function that posts to a given whiteboard.
 * Both the message type and the message content are strings.
 */
bool whiteboard_post_to(gu_simple_whiteboard_descriptor *wbd, const char *message_type, const char *message_content);

/**
 * Generic C function that posts a message with a given message number
 * to the whiteboard.
 */
bool whiteboard_postmsg(int message_index, const char *message_content);

/**
 * Generic C function that posts a message with a given message number
 * to a given whiteboard.
 */
bool whiteboard_postmsg_to(gu_simple_whiteboard_descriptor *wbd, int message_index, const char *message_content);

/**
 * Generic C function that returns the type for a given message name
 */

#ifndef __cplusplus
int whiteboard_type_for_message_named(const char *message_type);
#else
\(cppns)::\(cns)_types whiteboard_type_for_message_named(const char *message_type);
}

namespace \(cppns)
{
        /**
         * A generic C++ function that posts to the whiteboard.
         * Both the message type and the message content are strings.
         * @param message_type the string version of the type
         * @param message_content the string data to pass to the types string constructor
         * @param wbd whiteboard descriptor (NULLPTR for the default whiteboard)
         * @return true if there is a string constructor for the passed in type
         */
        bool post(std::string message_type, std::string message_content, gu_simple_whiteboard_descriptor *wbd = NULLPTR);

        /**
         * Generic C++ function that posts a message with a given message number
         * to the whiteboard.
         * @param message_index the offset or enum value of the type to post
         * @param message_content the string data to pass to the types string constructor
         * @param wbd whiteboard descriptor (NULLPTR for the default whiteboard)
         * @return true if there is a string constructor for the passed in type
         */
        bool postmsg(\(cppns)::\(cns)_types message_index, std::string message_content, gu_simple_whiteboard_descriptor *wbd = NULLPTR);

        /**
         * Map structure from strings to message types
         */
        struct whiteboard_types_map: public std::map<std::string, \(cppns)::\(cns)_types>
        {
                whiteboard_types_map(); ///< default constructor
        };

        /**
         * Global map from names to message types
         */
        extern struct whiteboard_types_map types_map;
}
#endif // __cplusplus

\(ifDefBottom)

"""
    }
}
