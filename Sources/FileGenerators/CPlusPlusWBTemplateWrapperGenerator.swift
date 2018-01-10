/**                                                                     
 *  /file CPlusPlusWBTemplateWrapperGenerator.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */              
                                                        
import Foundation

import DataStructures
import Protocols
import NamingFuncs

final public class CPlusPlusWBTemplateWrapperGenerator: FileGenerator {

    public typealias T = TSL

    public var name: String
    public var path: URL

    public init(path: URL) {
        self.name = "guwhiteboardtypelist_generated.h"
        self.path = path
    }

    public func createContent(obj: T) -> String {
        let copyright = FileGeneratorHelpers.createCopyright(fileName: self.name)
        let (ifDefTop, ifDefBottom) = FileGeneratorHelpers.createIfDefWrapper(fileName: self.name) 
        let tsl: TSL = obj //alias
        return """
\(copyright)

\(ifDefTop)

#include \"gugenericwhiteboardobject.h\"

#pragma clang diagnostic push
#pragma clang diagnostic ignored \"-Wpadded\"

namespace guWhiteboard
{
extern \"C\"
{
#include \"guwhiteboardtypelist_c_generated.h\"
}

	/** WB Ptr Class: Print @brief print to stdout */ 
        class Print_t: public generic_whiteboard_object<std::string > { 
	public: 
		/** Constructor: Print */ 
		Print_t(gu_simple_whiteboard_descriptor *wbd = NULL): generic_whiteboard_object<std::string >(wbd, kPrint_v, true) {}
		/** Constructor: Print */ 
		Print_t(std::string value, gu_simple_whiteboard_descriptor *wbd = NULL): generic_whiteboard_object<std::string >(value, kPrint_v, wbd, true) {} 
	};
}

#pragma clang diagnostic pop

\(ifDefBottom)
"""
    }
}

