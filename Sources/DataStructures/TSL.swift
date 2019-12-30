/**                                                                     
 *  /file TSL.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */                                                                     

import Protocols

final public class TSL: HasInit {
  public var wbNamespace : String
  public var useCustomNamespace : Bool
  public var entries: [TSLEntry]
  
  public init() {
    self.wbNamespace = "guWhiteboard"
    self.useCustomNamespace = false
    self.entries = []
  }
}
