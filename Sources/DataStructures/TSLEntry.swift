/**                                                                     
 *  /file TSLEntry.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */                                                                     

import Protocols

final public class TSLEntry: HasInit {

    public var type: MessageType
    public var atomic: AtomicFlag
    public var name: MsgName
    public var comment: MsgComment

    public init() {
        self.type = MessageType()
        self.atomic = AtomicFlag()
        self.name = MsgName()
        self.comment = MsgComment()
    }
}

