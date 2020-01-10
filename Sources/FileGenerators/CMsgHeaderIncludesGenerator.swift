/**                                                                     
 *  /file CMsgHeaderIncludesGenerator.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */               
                                                       
import Foundation

import DataStructures
import Protocols
import NamingFuncs

final public class CMsgHeaderIncludesGenerator: FileGenerator {

    public typealias T = TSL

    public var name: String
    public var path: URL
    public var config: Config

    public init(path: URL, config: Config) {
        self.name = "guwhiteboard_c_types.h"
        self.path = path
        self.config = config
    }

    public func createContent(obj: T) -> String {
        let copyright = FileGeneratorHelpers.createCopyright(fileName: self.name)
        let (ifDefTop, ifDefBottom) = FileGeneratorHelpers.createIfDefWrapper(fileName: self.name) 
        let tsl: TSL = obj //alias
        let classes: [TSLEntry] = tsl.entries
        let customClasses: [TSLEntry] = classes.filter { $0.type.isCustomTypeClass }
        let customGenClasses: [TSLEntry] = customClasses.filter { !$0.type.isLegacyCPlusPlusClassNaming }
        return """
\(copyright)

\(ifDefTop)

#include <gusimplewhiteboard/guwhiteboard_c_types_manual_definitions.h>

\(customGenClasses.map { entry in 
        return """

#include <typeClassDefs/\(NamingFuncs.createCStructName(entry.type)).h>
"""
        }.reduce("", +)
)

\(ifDefBottom)

"""
    }
}

