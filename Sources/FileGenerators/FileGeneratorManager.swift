/**                                                                     
 *  /file FileGeneratorManager.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */                                                                     

import Foundation

import DataStructures
import Protocols

final public class FileGeneratorManager {

    var tsl: TSL

    var typeEnumHeaderGenerator: TypeEnumHeaderGenerator
    /*
        CPlusPlusWBTemplateWrapperGenerator
        CPlusPlusTCPTemplateWrapperGenerator
        CPlusPlusWBTemplateFunctorGenerator

        CPlusPlusWBPosterGenerator
        CPlusPlusWBGetterGenerator

        CMsgSerialiseGenerator
        CMsgDeserialiseGenerator

        CTypeStringLookupGenerator
        */


    public init(tsl: TSL, wbPath: URL) {
        self.tsl = tsl
        typeEnumHeaderGenerator = TypeEnumHeaderGenerator(path: wbPath)
    }

    public func generate() {
        print("Generating Files.")
        typeEnumHeaderGenerator.generate(from: tsl) 
        /*
        cPlusPlusWBTemplateWrapperGenerator.generate(from: tsl) 
        cPlusPlusTCPTemplateWrapperGenerator.generate(from: tsl) 
        cPlusPlusWBTemplateFunctorGenerator.generate(from: tsl) 

        cPlusPlusWBPosterGenerator.generate(from: tsl) 
        cPlusPlusWBGetterGenerator.generate(from: tsl) 

        cMsgSerialiseGenerator.generate(from: tsl) 
        cMsgDeserialiseGenerator.generate(from: tsl) 

        cTypeStringLookupGenerator.generate(from: tsl) 
        */
    }
}

/* NEEDED
"guwhiteboardtypelist_c_generated.h"    TypeEnumHeaderGenerator

"guwhiteboardtypelist_generated.h"      CPlusPlusWBTemplateWrapperGenerator
"guwhiteboardtypelist_tcp_generated.h"  CPlusPlusTCPTemplateWrapperGenerator
"WBFunctor_types_generated.h"           CPlusPlusWBTemplateFunctorGenerator

"guwhiteboardposter.cpp"                CPlusPlusWBPosterGenerator
"guwhiteboardgetter.cpp"                CPlusPlusWBGetterGenerator

"guwhiteboardserialiser.c"              CMsgSerialiseGenerator
"guwhiteboarddeserialiser.c"            CMsgDeserialiseGenerator

"guwhiteboardtypelist_c_typestrings_generated.c"    CTypeStringLookupGenerator
*/

