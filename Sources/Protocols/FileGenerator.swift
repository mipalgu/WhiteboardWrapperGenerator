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
        var fm: FileManager = FileManager.default
        print("Saving '\(content)'")
/*

            let _ = try? self.fm.createDirectory(
                at: path,
                withIntermediateDirectories: false
            )



        guard let encoded = str.data(using: String.Encoding.utf8) else {
            return false
        }
        return self.fm.createFile(atPath: path.path, contents: encoded)
*/
    }
}
