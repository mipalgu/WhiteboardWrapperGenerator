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
import whiteboard_helpers

final public class CPlusPlusWBTemplateFunctorGenerator: FileGenerator {

    public typealias T = TSL

    public var name: String
    public var path: URL
    public var config: Config

    public init(path: URL, config: Config) {
        self.name = "WBFunctor_types_generated.h"
        self.path = path
        self.config = config
    }

    public func createContent(obj: T) -> String {
        let copyright = FileGeneratorHelpers.createCopyright(fileName: self.name)
        let (ifDefTop, ifDefBottom) = FileGeneratorHelpers.createIfDefWrapper(fileName: self.name, config: config) 
        let tsl: TSL = obj //alias
        let classes: [TSLEntry] = tsl.entries
        let cns = WhiteboardHelpers().cNamespace(of: config.cNamespaces)
        let cppns = WhiteboardHelpers().cppNamespace(of: config.cppNamespaces)
        return """
\(copyright)

\(ifDefTop)

#include <gu_util.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored \"-Wpadded\"
#pragma clang diagnostic ignored \"-Wold-style-cast\"

\(classes.map { entry in 
        let msgFunctorName = NamingFuncs.createMsgFunctorName(entry.name.string, config: config)
        let msgFunctorTemplate = NamingFuncs.createMsgFunctorTemplateName(entry.name.string, config: config)
        let CPlusPlusClassName = NamingFuncs.createCPlusPlusClassName(entry.type, config: config)
        let WBPtrClass = NamingFuncs.createCPlusPlusTemplateClassName(entry.name.string, config: config)
        let classNameOrPOD = entry.type.isCustomTypeClass ? CPlusPlusClassName : entry.type.typeName
        let isCustom: Bool = entry.type.isCustomTypeClass
        return """

        \(entry.type.isCustomTypeClass ? "#ifdef \(WhiteboardHelpers().cppDefinedDef(forClassNamed: CPlusPlusClassName, namespaces: config.cppNamespaces))" : "")
        /** WBFunctor definition for \(msgFunctorTemplate) */ 
        template <typename \(msgFunctorTemplate) >
        class \(msgFunctorName): public WBFunctor<\(msgFunctorTemplate) > {
        public:
            /** WBFunctor constructor for \(msgFunctorTemplate) */
            \(msgFunctorName)(\(msgFunctorTemplate)* obj, void (\(msgFunctorTemplate)::*pFunc) (\(cppns)::\(cns)_types, \(isCustom ? "\(cppns)::" : "")\(classNameOrPOD) &), \(cppns)::\(cns)_types t): WBFunctor<\(msgFunctorTemplate) >(obj, (void (\(msgFunctorTemplate)::*) (\(cppns)::\(cns)_types, gu_simple_message*))pFunc, t) { }
        
            /** call method for callbacks, for class \(msgFunctorName) */
            void call(gu_simple_message *m) OVERRIDE {
                \(isCustom ? "\(cppns)::" : "")\(classNameOrPOD) result = \(cppns)::\(WBPtrClass)().get_from(m);
                \(entry.name.string)_function_t funct((void (\(msgFunctorTemplate)::*)(\(cppns)::\(cns)_types, \(isCustom ? "\(cppns)::" : "")\(classNameOrPOD) &))WBFunctor<\(msgFunctorTemplate) >::get_s_func_ptr());
                (WBFunctor<\(msgFunctorTemplate) >::fObject->*funct)(WBFunctor<\(msgFunctorTemplate) >::type_enum, result);
            }
        
            /** define callback signature */
            typedef void (\(msgFunctorTemplate)::*\(entry.name.string)_function_t) (\(cppns)::\(cns)_types, \(isCustom ? "\(cppns)::" : "")\(classNameOrPOD) &);
        
            /** internal method of linking classes */
            static WBFunctorBase *bind(\(msgFunctorTemplate) *obj, void (\(msgFunctorTemplate)::*f)(\(cppns)::\(cns)_types, \(isCustom ? "\(cppns)::" : "")\(classNameOrPOD) &), \(cppns)::\(cns)_types t) { return new \(msgFunctorName)<\(msgFunctorTemplate) >(obj, f, t); }
        }; 
        \(entry.type.isCustomTypeClass ? "#endif //\(WhiteboardHelpers().cppDefinedDef(forClassNamed: CPlusPlusClassName, namespaces: config.cppNamespaces))" : "")

        """
        }.reduce("", +)
)

#pragma clang diagnostic pop

\(ifDefBottom)

"""
    }
}

