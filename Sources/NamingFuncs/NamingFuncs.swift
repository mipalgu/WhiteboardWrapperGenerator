/**                                                                     
 *  /file NamingFuncs.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */              
                                                        
import Foundation

final public class NamingFuncs {

    public static func createIfDefName(fileName: String) -> String {
        return fileName.uppercased().replacingOccurrences(of: ".", with: "_")
    }

    public static func createTypeEnumName(msgSlotName: String) -> String {
        return "k\(msgSlotName)_v"
    }


}

