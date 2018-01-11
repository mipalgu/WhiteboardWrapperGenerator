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

    var msgEnumHeaderGenerator: MsgEnumHeaderGenerator

    var cPlusPlusWBTemplateWrapperGenerator: CPlusPlusWBTemplateWrapperGenerator
    var cPlusPlusWBTemplateFunctorGenerator: CPlusPlusWBTemplateFunctorGenerator

    var cPlusPlusWBPosterGenerator: CPlusPlusWBPosterGenerator
    var cPlusPlusWBGetterGenerator: CPlusPlusWBGetterGenerator

    //var cMsgSerialiseGenerator: CMsgSerialiseGenerator
    //var cMsgDeserialiseGenerator: CMsgDeserialiseGenerator

    //var cTypeStringLookupGenerator: CTypeStringLookupGenerator

    public init(tsl: TSL, wbPath: URL) {
        self.tsl = tsl
        msgEnumHeaderGenerator = MsgEnumHeaderGenerator(path: wbPath)

        cPlusPlusWBTemplateWrapperGenerator = CPlusPlusWBTemplateWrapperGenerator(path: wbPath)
        cPlusPlusWBTemplateFunctorGenerator = CPlusPlusWBTemplateFunctorGenerator(path: wbPath)

        cPlusPlusWBPosterGenerator = CPlusPlusWBPosterGenerator(path: wbPath)
        cPlusPlusWBGetterGenerator = CPlusPlusWBGetterGenerator(path: wbPath)

        //cMsgSerialiseGenerator = CMsgSerialiseGenerator(path: wbPath)
        //cMsgDeserialiseGenerator = CMsgDeserialiseGenerator(path: wbPath)

        //cTypeStringLookupGenerator = CTypeStringLookupGenerator(path: wbPath)
    }

    public func generate() {
        msgEnumHeaderGenerator.generate(from: tsl) 

        cPlusPlusWBTemplateWrapperGenerator.generate(from: tsl) 
        cPlusPlusWBTemplateFunctorGenerator.generate(from: tsl) 

        cPlusPlusWBPosterGenerator.generate(from: tsl) 
        cPlusPlusWBGetterGenerator.generate(from: tsl) 

        //cMsgSerialiseGenerator.generate(from: tsl) 
        //cMsgDeserialiseGenerator.generate(from: tsl) 

        //cTypeStringLookupGenerator.generate(from: tsl) 
    }
}

/* NEEDED
"guwhiteboardserialiser.c"              CMsgSerialiseGenerator
"guwhiteboarddeserialiser.c"            CMsgDeserialiseGenerator

"guwhiteboardtypelist_c_typestrings_generated.c"    CTypeStringLookupGenerator
*/

