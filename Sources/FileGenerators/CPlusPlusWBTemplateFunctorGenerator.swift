/**                                                                     
 *  /file CPlusPlusWBTemplateFunctorGenerator.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */              
                                                        
import Foundation

import DataStructures
import Protocols
import NamingFuncs

final public class CPlusPlusWBTemplateFunctorGenerator: FileGenerator {

    public typealias T = TSL

    public var name: String
    public var path: URL

    public init(path: URL) {
        self.name = "WBFunctor_types_generated.h"
        self.path = path
    }

    public func createContent(obj: T) -> String {
        let headerName = (obj.useCustomNamespace ? obj.wbNamespace + "_" + self.name : self.name)
        let copyright = FileGeneratorHelpers.createCopyright(fileName: headerName)
        let (ifDefTop, ifDefBottom) = FileGeneratorHelpers.createIfDefWrapper(fileName: headerName) 
        let tsl: TSL = obj //alias
        let classes: [TSLEntry] = tsl.entries
        return """
\(copyright)

/** Auto-generated, don't modify! */

\(ifDefTop)

#pragma clang diagnostic push
#pragma clang diagnostic ignored \"-Wpadded\"
#pragma clang diagnostic ignored \"-Wold-style-cast\"

\(classes.map { entry in 
        let msgFunctorName = NamingFuncs.createMsgFunctorName(entry.name.string)
        let msgFunctorTemplate = NamingFuncs.createMsgFunctorTemplateName(entry.name.string)
        let CPlusPlusClassName = NamingFuncs.createCPlusPlusClassName(entry.type)
        let WBPtrClass = NamingFuncs.createCPlusPlusTemplateClassName(entry.name.string)
        let classNameOrPOD = entry.type.isCustomTypeClass ? CPlusPlusClassName : entry.type.typeName
        let isCustom: Bool = entry.type.isCustomTypeClass
//\(obj.useCustomNamespace ? "guWhiteboard::" +  obj.wbNamespace + "::" : "")
      return """

        \(entry.type.isCustomTypeClass ? "#ifdef \(CPlusPlusClassName)_DEFINED" : "")
        /** WBFunctor definition for \(msgFunctorTemplate) */ 
        template <typename \(msgFunctorTemplate) >
        class \(msgFunctorName): public WBFunctor<\(msgFunctorTemplate) > {
        public:
            /** WBFunctor constructor for \(msgFunctorTemplate) */
        \(msgFunctorName)(\(msgFunctorTemplate)* obj, void (\(msgFunctorTemplate)::*pFunc) (guWhiteboard::\(obj.useCustomNamespace ? obj.wbNamespace + "::" + obj.wbNamespace + "_" : "")WBTypes, \(isCustom ? "guWhiteboard::" : "")\(classNameOrPOD) &), guWhiteboard::\(obj.useCustomNamespace ? obj.wbNamespace + "::" + obj.wbNamespace + "_" : "")WBTypes t): WBFunctor<\(msgFunctorTemplate) >(obj, (void (\(msgFunctorTemplate)::*) (guWhiteboard::\(obj.useCustomNamespace ? obj.wbNamespace + "::" + obj.wbNamespace + "_" : "")WBTypes, gu_simple_message*))pFunc, t) { }
        
            /** call method for callbacks, for class \(msgFunctorName) */
            void call(gu_simple_message *m) {
                \(isCustom ? "guWhiteboard::" : "")\(classNameOrPOD) result = guWhiteboard:: \(obj.useCustomNamespace ? obj.wbNamespace + "::" : "")\(WBPtrClass)().get_from(m);
        \(entry.name.string)_function_t funct((void (\(msgFunctorTemplate)::*)(guWhiteboard::\(obj.useCustomNamespace ? obj.wbNamespace + "::" + obj.wbNamespace + "_" : "")WBTypes, \(isCustom ? "guWhiteboard::" : "")\(classNameOrPOD) &))WBFunctor<\(msgFunctorTemplate) >::get_s_func_ptr());
                (WBFunctor<\(msgFunctorTemplate) >::fObject->*funct)(WBFunctor<\(msgFunctorTemplate) >::type_enum, result);
            }
        
            /** define callback signature */
            typedef void (\(msgFunctorTemplate)::*\(entry.name.string)_function_t) (guWhiteboard::\(obj.useCustomNamespace ? obj.wbNamespace + "::" + obj.wbNamespace + "_" : "")WBTypes, \(isCustom ? "guWhiteboard::" : "")\(classNameOrPOD) &);
        
            /** internal method of linking classes */
            static WBFunctorBase *bind(\(msgFunctorTemplate) *obj, void (\(msgFunctorTemplate)::*f)(guWhiteboard::\(obj.useCustomNamespace ? obj.wbNamespace + "::" + obj.wbNamespace + "_" : "")WBTypes, \(isCustom ? "guWhiteboard::" : "")\(classNameOrPOD) &), guWhiteboard::\(obj.useCustomNamespace ? obj.wbNamespace + "::" + obj.wbNamespace + "_" : "")WBTypes t) { return new \(msgFunctorName)<\(msgFunctorTemplate) >(obj, f, t); }
        }; 
        \(entry.type.isCustomTypeClass ? "#endif //\(CPlusPlusClassName)_DEFINED" : "")

        """
        }.reduce("", +)
)

#pragma clang diagnostic pop

\(ifDefBottom)

"""
    }
}

