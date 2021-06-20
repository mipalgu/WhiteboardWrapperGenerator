/**                                                                     
 *  /file CMsgSerialisationHeaderGenerator.swift
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

final public class CMsgSerialisationHeaderGenerator: FileGenerator {

    public typealias T = TSL

    public var name: String
    public var path: URL
    public var config: Config

    public init(path: URL, config: Config) {
        self.name = "guwhiteboardserialisation.h"
        self.path = path
        self.config = config
    }

    public func createContent(obj: T) -> String {
        let copyright = FileGeneratorHelpers.createCopyright(fileName: self.name)
        let (ifDefTop, ifDefBottom) = FileGeneratorHelpers.createIfDefWrapper(fileName: self.name, config: config) 
        let cns = WhiteboardHelpers().cNamespace(of: config.cNamespaces)
        return """
\(copyright)

/** Auto-generated, don't modify! */

\(ifDefTop)

#ifndef __cplusplus
#include <stdbool.h>
#else
#if __cplusplus < 201103L
#include <stdbool.h>
#else
#include <cstdbool>
#endif
#endif // __cplusplus

#include "guwhiteboardtypelist_c_generated.h"

int32_t serialisemsg(\(cns)_types message_index, const void *message_in, void *serialised_out);

int32_t deserialisemsg(\(cns)_types message_index, const void *serialised_in, void *message_out);

\(ifDefBottom)

"""
    }
}

