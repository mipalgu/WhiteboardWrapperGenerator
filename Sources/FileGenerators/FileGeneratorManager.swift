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
    var config: Config

    var msgEnumHeaderGenerator: MsgEnumHeaderGenerator

    var cPlusPlusWBTemplateWrapperGenerator: CPlusPlusWBTemplateWrapperGenerator
    var cPlusPlusWBTemplateFunctorGenerator: CPlusPlusWBTemplateFunctorGenerator
    var cPlusPlusWBFunctorGenerator: CPlusPlusWBFunctorGenerator
    

    var cPlusPlusWBPosterGenerator: CPlusPlusWBPosterGenerator
    var cPlusPlusWBPosterHeaderGenerator: CPlusPlusWBPosterHeaderGenerator
    var cPlusPlusWBGetterGenerator: CPlusPlusWBGetterGenerator
    var cPlusPlusWBGetterHeaderGenerator: CPlusPlusWBGetterHeaderGenerator

    var cMsgSerialiseGenerator: CMsgSerialiseGenerator
    var cMsgDeserialiseGenerator: CMsgDeserialiseGenerator
    var cMsgSerialisationHeaderGenerator: CMsgSerialisationHeaderGenerator 

    var cTypeStringLookupGenerator: CTypeStringLookupGenerator

    var cMsgHeaderIncludesGenerator: CMsgHeaderIncludesGenerator

    var cPlusPlusCustomGenericWhiteboardObjectHeader: CPlusPlusCustomGenericWhiteboardObjectHeader
    var cPlusPlusCustomGenericWhiteboardObjectImplementation: CPlusPlusCustomGenericWhiteboardObjectImplementation
    

    public init(tsl: TSL, wbPath: URL, config: Config) {
        self.tsl = tsl
        self.config = config
        msgEnumHeaderGenerator = MsgEnumHeaderGenerator(path: wbPath, config: config)

        cPlusPlusWBTemplateWrapperGenerator = CPlusPlusWBTemplateWrapperGenerator(path: wbPath, config: config)
        cPlusPlusWBTemplateFunctorGenerator = CPlusPlusWBTemplateFunctorGenerator(path: wbPath, config: config)
        cPlusPlusWBFunctorGenerator = CPlusPlusWBFunctorGenerator(path: wbPath, config: config)


        cPlusPlusWBPosterGenerator = CPlusPlusWBPosterGenerator(path: wbPath, config: config)
        cPlusPlusWBPosterHeaderGenerator = CPlusPlusWBPosterHeaderGenerator(path: wbPath, config: config)
        cPlusPlusWBGetterGenerator = CPlusPlusWBGetterGenerator(path: wbPath, config: config)
        cPlusPlusWBGetterHeaderGenerator = CPlusPlusWBGetterHeaderGenerator(path: wbPath, config: config)

        cMsgSerialiseGenerator = CMsgSerialiseGenerator(path: wbPath, config: config)
        cMsgDeserialiseGenerator = CMsgDeserialiseGenerator(path: wbPath, config: config)
        cMsgSerialisationHeaderGenerator = CMsgSerialisationHeaderGenerator(path: wbPath, config: config)

        cTypeStringLookupGenerator = CTypeStringLookupGenerator(path: wbPath, config: config)

        cMsgHeaderIncludesGenerator = CMsgHeaderIncludesGenerator(path: wbPath, config: config)

        cPlusPlusCustomGenericWhiteboardObjectHeader = CPlusPlusCustomGenericWhiteboardObjectHeader(path: wbPath, config: config)
        cPlusPlusCustomGenericWhiteboardObjectImplementation = CPlusPlusCustomGenericWhiteboardObjectImplementation(path: wbPath, config: config)
    }

    public func generate() {
        msgEnumHeaderGenerator.generate(from: tsl) 

        cPlusPlusWBTemplateWrapperGenerator.generate(from: tsl) 
        cPlusPlusWBTemplateFunctorGenerator.generate(from: tsl) 
        cPlusPlusWBFunctorGenerator.generate(from: tsl) 

        cPlusPlusWBPosterGenerator.generate(from: tsl) 
        cPlusPlusWBPosterHeaderGenerator.generate(from: tsl) 
        cPlusPlusWBGetterGenerator.generate(from: tsl) 
        cPlusPlusWBGetterHeaderGenerator.generate(from: tsl) 

        cMsgSerialiseGenerator.generate(from: tsl) 
        cMsgDeserialiseGenerator.generate(from: tsl)
        cMsgSerialisationHeaderGenerator.generate(from: tsl)

        cTypeStringLookupGenerator.generate(from: tsl) 

        cMsgHeaderIncludesGenerator.generate(from: tsl) 

        cPlusPlusCustomGenericWhiteboardObjectHeader.generate(from: tsl)
        cPlusPlusCustomGenericWhiteboardObjectImplementation.generate(from: tsl)
    }
}

