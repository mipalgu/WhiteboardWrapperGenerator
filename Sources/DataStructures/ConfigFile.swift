/**                                                                     
 *  /file ConfigFile.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */                                                                     

import Protocols
import whiteboard_helpers

final public class Config: ConfigFile {

    public var tslName: String
    public var defaultWhiteboardName: String
    public var namespaces: [Namespace]
    public var acceptableTypes: AcceptableTypes

    public var cNamespaces: [CNamespace] {
        get {
            self.namespaces.compactMap {
                if let cns = $0.cNamespace {
                    return cns
                }
                if let cppns = $0.cppNamespace {
                    return WhiteboardHelpers().toCNamespace(cppNamespace: cppns)
                }
                else {
                    return nil
                }
            }
        }
    }

    public var cppNamespaces: [CPPNamespace] {
        get {
            self.namespaces.compactMap {
                if let cppns = $0.cppNamespace {
                    return cppns
                }
                if let cns = $0.cNamespace {
                    return WhiteboardHelpers().toCPPNamespace(cNamespace: cns)
                }
                else {
                    return nil
                }
            }
        }
    }


    public init() {
        //default values
        self.tslName = "guwhiteboardtypelist.tsl"
        self.defaultWhiteboardName = "guWhiteboard"
        self.namespaces = [Namespace(cNamespace: "wb", cppNamespace: "guWhiteboard")]
        self.acceptableTypes = AcceptableTypes()
    }
}

