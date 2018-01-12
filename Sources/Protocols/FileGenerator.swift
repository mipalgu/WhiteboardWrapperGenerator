/**                                                                     
 *  /file FileGenerator.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */                                                                     

import Foundation

public protocol FileGenerator {

    associatedtype T
    var name: String { get set }
    var path: URL { get set }

    init(path: URL) 

    func createContent(obj: T) -> String

    func generate(from: T)
}

public extension FileGenerator {

    func generate(from: T)
    {
        let content:String = createContent(obj: from)
        let fm: FileManager = FileManager.default
        
        guard let _ = try? fm.createDirectory(
            at: path,
            withIntermediateDirectories: true) else {
                fatalError("Could not create '\(path.path)'")
            }

        guard let encoded = content.data(using: String.Encoding.utf8) else {
            fatalError("Could not handle file content for '\(name)'")
        }

        if !fm.createFile(atPath: path.appendingPathComponent(name).path, contents: encoded) {
            fatalError("Could not save the file '\(name)'")
        }
    }
}
