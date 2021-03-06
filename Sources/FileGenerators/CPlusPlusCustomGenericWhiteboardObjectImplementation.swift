/**                                                                     
 *  /file CPlusPlusCustomGenericWhiteboardObjectImplementation.swift
 *                                                                      
 *  Created by Carl Lusty in 2020.
 *  Copyright (c) 2020 Carl Lusty                                       
 *  All rights reserved.                                                
 */               
                                                       
import Foundation

import DataStructures
import Protocols
import NamingFuncs
import whiteboard_helpers

final public class CPlusPlusCustomGenericWhiteboardObjectImplementation : FileGenerator {

    public typealias T = TSL
    public var name: String
    public var path: URL
    public var config: Config

    public init(path: URL, config: Config) {
        self.name = config.defaultWhiteboardName + "_gugenericwhiteboardobject.cpp"
        self.path = path
        self.config = config
    }

    public func createContent(obj: T) -> String {
        let copyright = FileGeneratorHelpers.createCopyright(fileName: self.name)
        let wbNamePrefix = self.config.defaultWhiteboardName + "_"
        let ntd = WhiteboardHelpers().createDefName(forClassNamed: "NUM_TYPES_DEFINED", namespaces: config.cNamespaces)
        return """
\(copyright)


/** Auto-generated, don't modify! */

#include "\(wbNamePrefix)gugenericwhiteboardobject.h"
#include "guwhiteboardtypelist_c_generated.h"

#include <stdlib.h>

static void create_\(wbNamePrefix)singleton_whiteboard(void *);

static gu_simple_whiteboard_descriptor *\(wbNamePrefix)whiteboard_descriptor;

static void create_\(wbNamePrefix)singleton_whiteboard(void *)
{
    const char *name = "\(self.config.defaultWhiteboardName)";

#ifndef GSW_IOS_DEVICE
    const char *env = getenv(GSW_DEFAULT_ENV);
    if (env && *env) name = env;
#endif

//taken from gusimplewhiteboard.c, should we make this from a hash of the whiteboard name?
#define SEMAPHORE_MAGIC_KEY     4242

    \(wbNamePrefix)whiteboard_descriptor = gsw_new_custom_whiteboard(
        name, 
        \(WhiteboardHelpers().cNamespace(of: config.cNamespaces))_types_stringValues,
        \(ntd),
        SEMAPHORE_MAGIC_KEY
    );
}

gu_simple_whiteboard_descriptor *get_\(wbNamePrefix)singleton_whiteboard(void)
{
#ifdef WITHOUT_LIBDISPATCH	// not thread-safe without libdispatch!
	if (!\(wbNamePrefix)whiteboard_descriptor)
	{
		\(wbNamePrefix)whiteboard_descriptor = (gu_simple_whiteboard_descriptor *)~0;
		create_\(wbNamePrefix)singleton_whiteboard(NULLPTR);
	}
#else
	static dispatch_once_t onceToken;
	dispatch_once_f(&onceToken, NULLPTR, create_\(wbNamePrefix)singleton_whiteboard);
#endif
	return \(wbNamePrefix)whiteboard_descriptor;
}

"""
    }
}

