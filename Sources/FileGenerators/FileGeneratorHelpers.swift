/**                                                                     
 *  /file FileGeneratorHelpers.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */              
                                                        
import Foundation
import NamingFuncs 
import DataStructures

final public class FileGeneratorHelpers {

    public static func createCopyright(fileName: String) -> String {
        return """
        /**
         *  /file \(fileName)
         *
         *  Created by Carl Lusty in 2018.
         *  Copyright (c) 2013-2020 Carl Lusty and Rene Hexel
         *  All rights reserved.
         */
        """
    }

    public static func createIfDefWrapper(fileName: String, config: Config) -> (String, String) {
        let defineName: String = NamingFuncs.createIfDefName(fileName: fileName, config: config)
        return (createIfDefTop(defineName: defineName), 
                createIfDefBottom(defineName: defineName))
    }

    static func createIfDefTop(defineName: String) -> String {
        return """
            #ifndef \(defineName)
            #define \(defineName)
            """
    }

    static func createIfDefBottom(defineName: String) -> String {
        return """
            #endif //\(defineName)
            """
    }
}

