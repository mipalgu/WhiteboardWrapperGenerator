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


    public init(tsl: TSL, wbPath: URL) {
        self.tsl = tsl
        typeEnumHeaderGenerator = TypeEnumHeaderGenerator(path: wbPath)
    }

    public func generate() {
        print("Generating Files.")
        typeEnumHeaderGenerator.generate(from: tsl) 
    }
}

