/**                                                                     
 *  /file CPlusPlusCustomGenericWhiteboardObjectHeader.swift
 *                                                                      
 *  Created by Carl Lusty in 2020.
 *  Copyright (c) 2020 Carl Lusty                                       
 *  All rights reserved.                                                
 */               
                                                       
import Foundation

import DataStructures
import Protocols
import NamingFuncs

final public class CPlusPlusCustomGenericWhiteboardObjectHeader : FileGenerator {

    public typealias T = TSL
    public var name: String
    public var path: URL
    public var config: Config

    public init(path: URL, config: Config) {
        self.name = config.defaultWhiteboardName + "_gugenericwhiteboardobject.h"
        self.path = path
        self.config = config
    }

    public func createContent(obj: T) -> String {
        let copyright = FileGeneratorHelpers.createCopyright(fileName: self.name)
        let (ifDefTop, ifDefBottom) = FileGeneratorHelpers.createIfDefWrapper(fileName: self.name) 
        let wbNamePrefix = self.config.defaultWhiteboardName + "_"
        return """
\(copyright)

\(ifDefTop)

/** Auto-generated, don't modify! */

#include "gugenericwhiteboardobject.h"

//Prototype for custom singleton whiteboard methods.
gu_simple_whiteboard_descriptor *get_\(wbNamePrefix)singleton_whiteboard(void);

template <class object_type> class \(wbNamePrefix)generic_whiteboard_object : public generic_whiteboard_object<object_type>
{
public:
    /**                                                                                                                   
     * designated constructor
    */
    \(wbNamePrefix)generic_whiteboard_object(gu_simple_whiteboard_descriptor *wbd, uint16_t toffs, bool want_atomic = true, bool do_notify_subscribers = true) : generic_whiteboard_object<object_type>(wbd, toffs, want_atomic, do_notify_subscribers)
    {

    }

    /**
     * value conversion reference constructor
    */
    \(wbNamePrefix)generic_whiteboard_object(const object_type &value, uint16_t toffs, gu_simple_whiteboard_descriptor *wbd = NULLPTR, bool want_atomic = true) : generic_whiteboard_object<object_type>(value, toffs, wbd, want_atomic)
    {

    }

    /**
     * intialiser (called from constructors)
     * This is specific to a custom whiteboard, this way the default singleton whiteboard is correct.
    */
    void init(uint16_t toffs, gu_simple_whiteboard_descriptor *wbd = NULLPTR, bool want_atomic = true, bool do_notify_subscribers = true)
    {
        if(!wbd)
        {
            wbd = get_\(wbNamePrefix)singleton_whiteboard();
        }
        this->type_offset = toffs;
        this->atomic = want_atomic;
        this->notify_subscribers = do_notify_subscribers;
        this->_wbd = wbd;
    }
};

\(ifDefBottom)

"""
    }
}

