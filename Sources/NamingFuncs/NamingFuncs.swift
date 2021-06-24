/**                                                                     
 *  /file NamingFuncs.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */              
                                                        
import Foundation
import DataStructures
import whiteboard_helpers

final public class NamingFuncs {

    public static func createCPlusPlusClassName(_ type: MessageType, config: Config) -> String {
        if type.isLegacyCPlusPlusClassNaming {
            return "\(type.typeName)"
        }
        else {
            return WhiteboardHelpers().createClassName(forClassNamed: type.typeName)
        }
    }

    public static func createCPlusPlusClassNameWithNamespace(_ type: MessageType, config: Config) -> String {
        if type.isLegacyCPlusPlusClassNaming {
            return "\(type.typeName)"
        }
        else {
            return WhiteboardHelpers().createNamespacedClassName(forClassNamed: type.typeName, namespaces: config.cppNamespaces)
        }
    }
    
    public static func createCStructName(_ type: MessageType, config: Config) -> String {
        if type.isLegacyCPlusPlusClassNaming {
            return "NotSupportedWithLegacyNaming"
        }
        else {
            return WhiteboardHelpers().createStructName(forClassNamed: type.typeName, namespaces: config.cNamespaces)
        }
    }

    public static func createIfDefName(fileName: String, config: Config) -> String {
        //include guard
        if fileName.contains(".cpp") {
            return WhiteboardHelpers().includeGuard(forCPPHeader: fileName, namespaces: config.cppNamespaces)
        }
        else {
            return WhiteboardHelpers().includeGuard(forCPPHeader: fileName, namespaces: config.cNamespaces)
        }
    }

    public static func createMsgEnumName(_ name: String, config: Config) -> String {
        return "k_\(name)_v"
    }

    public static func createCPlusPlusTemplateClassName(_ msgSlotName: String, config: Config) -> String {
        return msgSlotName + "_t"
    }

    public static func createCPlusPlusTemplateDataType(_ type: MessageType, config: Config) -> String {
        if type.isCustomTypeClass {
            return "class " + createCPlusPlusClassName(type, config: config)
        }
        return type.typeName 
    }

    public static func createMsgFunctorName(_ msgName: String, config: Config) -> String {
        return msgName + "_WBFunctor"
    }

    public static func createMsgFunctorTemplateName(_ msgName: String, config: Config) -> String {
        return msgName + "_WBFunctor_T"
    }

    public static func createWasClassGeneratedFlag(_ type: MessageType, config: Config) -> String {
        if type.isLegacyCPlusPlusClassNaming {
            return "SerialisationNotSupportedWithLegacyNaming"
        }
        else {
            return type.typeName.uppercased() + "_GENERATED"
        }
    }

    public static func createClassGeneratorCStructFlag(_ type: MessageType, config: Config) -> String {
        if type.isLegacyCPlusPlusClassNaming {
            return "NotSupportedWithLegacyNaming"
        }
        else {
            return type.typeName.uppercased() + "_C_STRUCT"
        }
    }
}

