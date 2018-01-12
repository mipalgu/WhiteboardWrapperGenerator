/**                                                                     
 *  /file NamingFuncs.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */              
                                                        
import Foundation
import DataStructures

final public class NamingFuncs {

    public static func createIfDefName(fileName: String) -> String {
        return fileName.uppercased().replacingOccurrences(of: ".", with: "_")
    }

    public static func createMsgEnumName(_ name: String) -> String {
        return "k\(name)_v"
    }

    public static func createCPlusPlusClassName(_ type: MessageType) -> String {
        if type.isLegacyCPlusPlusClassNaming {
            return "\(type.typeName)"
        }
        else {
            //TODO pass to callums snakeCase thingy
            return "gen_\(type.typeName)"
        }
    }
    
    public static func createCStructName(_ type: MessageType) -> String {
        if type.isLegacyCPlusPlusClassNaming {
            return "NotSupportedWithLegacyNaming"
        }
        else {
            return "CallumsgenToStructFuncCall"
        }
    }

    public static func createCPlusPlusTemplateClassName(_ msgSlotName: String) -> String {
        return msgSlotName + "_t"
    }

    public static func createCPlusPlusTemplateDataType(_ type: MessageType) -> String {
        if type.isCustomTypeClass {
            return "class " + createCPlusPlusClassName(type)
        }
        return type.typeName 
    }

    public static func createMsgFunctorName(_ msgName: String) -> String {
        return msgName + "_WBFunctor"
    }

    public static func createMsgFunctorTemplateName(_ msgName: String) -> String {
        return msgName + "_WBFunctor_T"
    }

    public static func createWasClassGeneratedFlag(_ type: MessageType) -> String {
        if type.isLegacyCPlusPlusClassNaming {
            return "SerialisationNotSupportedWithLegacyNaming"
        }
        else {
            return type.typeName.uppercased() + "_GENERATED"
        }
    }

    public static func createClassGeneratorCStructFlag(_ type: MessageType) -> String {
        if type.isLegacyCPlusPlusClassNaming {
            return "NotSupportedWithLegacyNaming"
        }
        else {
            return type.typeName.uppercased() + "_C_STRUCT"
        }
    }
}

