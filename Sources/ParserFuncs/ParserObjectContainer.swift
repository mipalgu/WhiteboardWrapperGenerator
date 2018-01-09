/**                                                                     
 *  /file ParserObjectContainer.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */                                                                     

import Protocols

final public class ParserObjectContainer<T: HasInit> {

    public var object: T?
    public var warnings: [ParserMessage]
    public var error: ParserMessage?
    public var currentLocation: String

    public init(location: String = "") {
        self.object = T()
        self.warnings = []
        self.error = nil
		self.currentLocation = location
    }

    public func set(object: T) {
        self.object = object
    }

    public func hasError() -> Bool {
        return self.error != nil
    }

    public func addWarning(msg: String) {
        self.addWarning(msg: ParserMessage(msg: msg, location: self.currentLocation))
    }

    func addWarning(msg: ParserMessage) {
        self.warnings.append(msg)
    }

    public func error(msg: String) -> ParserObjectContainer<T> {
        return self.error(msg: ParserMessage(msg: msg, location: self.currentLocation))
    }

    func error(msg: ParserMessage) -> ParserObjectContainer<T> {
        self.object = nil
        self.error = msg
        return self
    }

	public func concat<T2>(append: ParserObjectContainer<T2>, objAppend: (T, T2) -> T)
	{
		if let oldObj = self.object, let newObj = append.object {
			self.object = objAppend(oldObj, newObj)
		}
        let newWarnings: [ParserMessage] = append.warnings.map { 
            $0.location = currentLocation + $0.location
            return $0
        }
        self.warnings = self.warnings + newWarnings

        if let e = append.error {
            e.location = currentLocation + e.location
            self.error = e
        }
	}
}

