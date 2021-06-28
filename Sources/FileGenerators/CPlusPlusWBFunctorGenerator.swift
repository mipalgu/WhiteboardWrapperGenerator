/**                                                                     
 *  /file CPlusPlusWBFunctorGenerator.swift
 *                                                                      
 *  Created by Carl Lusty in 2021.                                      
 *  Copyright (c) 2021 Carl Lusty                                       
 *  All rights reserved.                                                
 */              
                                                        
import Foundation

import DataStructures
import Protocols
import NamingFuncs
import whiteboard_helpers

final public class CPlusPlusWBFunctorGenerator: FileGenerator {

    public typealias T = TSL

    public var name: String
    public var path: URL
    public var config: Config

    public init(path: URL, config: Config) {
        self.name = "WBFunctor.h"
        self.path = path
        self.config = config
    }

    public func createContent(obj: T) -> String {
        let (ifDefTop, ifDefBottom) = FileGeneratorHelpers.createIfDefWrapper(fileName: self.name, config: config) 
        let cppns = WhiteboardHelpers().cppNamespace(of: config.cppNamespaces)
        return """
/* MiPAL 2010
Author: Tyrone Trevorrow, Carl Lusty, and Rene Hexel
Purpose: Provides a more generic mechanism for function callbacks.
		 Feel free to extend this to support any function's parameter lists.
 Change Log:
        21/1/2013 - Extended to add simple wb compatability, Carl.
*/

\(ifDefTop)

#ifdef bool
#undef bool
#endif

#ifdef true
#undef true
#undef false
#endif

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#pragma clang diagnostic ignored "-Wpadded"

#include <string>
#include <gu_util.h>

#include "WBMsg.h"
#include "guwhiteboardtypelist_generated.h" //for type enum
#include "gusimplewhiteboard.h" //for gu_simple_message

#define \(WhiteboardHelpers().createDefName(forClassNamed: "BIND", namespaces: config.cNamespaces))( f ) createWBFunctor(this, &f)
#define \(WhiteboardHelpers().createDefName(forClassNamed: "TYPE_BIND", namespaces: config.cNamespaces))( t, f ) createWBFunctor(this, &f, t)

/**
 * @brief Base class for WBFunctor 
 *
 * This class provides outlines the interface for WBFunctor. It is designed to assist with managing callbacks
*/     
class WBFunctorBase
{
public:
	/**
 	* Call method for the OLD whiteboard callbacks that used WBMsg - Deprecated
	* @param s type string value
	* @param m WBMsg data value
	*/
	virtual void call(std::string s, WBMsg* m) = 0;                         //old wbmsg format for callbacks

	/**
 	* Call method for the 'simple' whiteboard aka 'typed whiteboard' callbacks that passes data around in a union
	* @param m data value
	*/
	virtual void call(gu_simple_message* m) = 0;                            //new simple_message callbacks

	/**
 	* Call method for the 'simple' whiteboard aka 'typed whiteboard' callbacks that passes data around in a union. This version allows a 'type' overwrite. This is mostly used by the 'whiteboard poster' to impersonate other message types.
	* @param t whiteboard 'type' 
	* @param m data value
	*/
	virtual void call(\(cppns)::WBTypes t, gu_simple_message* m) = 0;   //new simple_message callbacks (with type overwrite for subscribe to all special type)

	/** getter for the WB type */
    virtual \(cppns)::WBTypes type() = 0;

	/** getter for the WB event counter */
    virtual uint16_t get_event_count() = 0;

	/** 
	* setter for the WB event counter 
	* @param e new event counter value
	*/
    virtual void set_event_count(uint16_t e) = 0;

	/** is this being used by the 'simple whiteboard' or the OLD whiteboard (which is now Deprecated) */
    virtual bool is_simple_wb_version() = 0;

	/** destructor */
	virtual ~WBFunctorBase(){}
};

/**
 * @brief WBFunctor callback manager class 
 *
 * This class allows you to pass a function pointer for callbacks
*/
template <typename C>
class WBFunctor: public WBFunctorBase
{
public:
	/**
 	* WBFunctor Constructor
	*/
	WBFunctor(C* obj, void (C::*pFunc) (std::string, WBMsg*)):
		fObject(obj), fFunction(pFunc), simple_wb_version(false) { }

	/**
 	* WBFunctor Constructor
	*/
	WBFunctor(C* obj, void (C::*pFunc) (\(cppns)::WBTypes, gu_simple_message*), \(cppns)::WBTypes t):
        fObject(obj), s_fFunction(pFunc), type_enum(t), event_count(0), simple_wb_version(true) { }

	/**
 	* Call method for the OLD whiteboard callbacks that used WBMsg - Deprecated
	* @param s type string value
	* @param m WBMsg data value
	*/
	void call(std::string s, WBMsg* m) OVERRIDE
	{
		(fObject->*fFunction)(s,m);
	}

	/**
 	* Call method for the 'simple' whiteboard aka 'typed whiteboard' callbacks that passes data around in a union
	* @param m data value
	*/
	void call(gu_simple_message* m) OVERRIDE
	{
		(fObject->*s_fFunction)(type_enum, m);
	}

	/**
 	* Call method for the 'simple' whiteboard aka 'typed whiteboard' callbacks that passes data around in a union. This version allows a 'type' overwrite. This is mostly used by the 'whiteboard poster' to impersonate other message types.
	* @param t whiteboard 'type' 
	* @param m data value
	*/
	void call(\(cppns)::WBTypes t, gu_simple_message* m) OVERRIDE
	{
		(fObject->*s_fFunction)(t, m);
	}

	/** getter for the WB type */
	\(cppns)::WBTypes type() OVERRIDE { return type_enum; }

	/** getter for the WB event counter */
	uint16_t get_event_count() OVERRIDE { return event_count; }

	/** 
	* setter for the WB event counter 
	* @param e new event counter value
	*/
	void set_event_count(uint16_t e) OVERRIDE { event_count = e; }

	/** is this being used by the 'simple whiteboard' or the OLD whiteboard (which is now Deprecated) */
	bool is_simple_wb_version() OVERRIDE { return simple_wb_version; }

	/** function prototype for the new 'simple whiteboard' callbacks */
	typedef void (C::*s_func) (\(cppns)::WBTypes, gu_simple_message*); //simple wb implementation

	/** getter */
	s_func get_s_func_ptr() { return s_fFunction; }

protected:
	C* fObject; ///< ptr to call containing the callback method
	typedef void (C::*func) (std::string, WBMsg*); ///< OLD function prototype (which is now Deprecated)
	func fFunction; ///< OLD function object
	s_func s_fFunction; ///< 'simple' function object
	\(cppns)::WBTypes type_enum; ///< 'simple' whiteboard types
	uint16_t event_count; ///< the event counter
	bool simple_wb_version; ///< flag, is this a 'simple' whiteboard usage of WBFunctor
};

template <typename C>
WBFunctorBase* createWBFunctor(C *obj, void (C::*f) (std::string, WBMsg*))
{
	return new WBFunctor<C>(obj, f);
}
template <typename C>
WBFunctorBase* createWBFunctor(C *obj, void (C::*f) (\(cppns)::WBTypes, gu_simple_message*), \(cppns)::WBTypes t)
{
	return new WBFunctor<C>(obj, f, t);
}



#pragma clang diagnostic pop

#include "WBFunctor_types_generated.h"

\(ifDefBottom)

"""
    }
}

