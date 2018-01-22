/**                                                                     
 *  /file ConfigFile.swift
 *                                                                      
 *  Created by Carl Lusty in 2018.                                      
 *  Copyright (c) 2018 Carl Lusty                                       
 *  All rights reserved.                                                
 */                                                                     

import Foundation

public protocol ConfigFile: Codable {

    init()
    init?(file: URL)

    static func findConfig(name: String, paths: [String]) -> URL?
    static func findConfig(name: String, paths: [URL]) -> URL?

    static func fileExists(url: URL) -> Bool
    mutating func load(file: URL) -> Bool
    func save(file: URL) -> Bool
}

public extension ConfigFile {

    init?(file: URL) {
        guard Self.fileExists(url: file) else {
            return nil
        }
        self.init()
        if !self.load(file: file) {
            return nil
        }
    }

    static func findConfig(name: String, paths: [String]) -> URL? {
        let urlPaths: [URL] = paths.map { URL(fileURLWithPath: $0) }
        return Self.findConfig(name: name, paths: urlPaths)
    }

    static func findConfig(name: String, paths: [URL]) -> URL? {
        let urls: [URL] = paths.map { $0.appendingPathComponent(name) }
        let fileM = urls.first { Self.fileExists(url: $0) }
        return fileM ?? nil
    }

    static func fileExists(url: URL) -> Bool {
        let fm: FileManager = FileManager.default
#if os(OSX)
        var isDirectory: ObjCBool = false
        let fileExists: Bool = fm.fileExists(atPath: url.path, isDirectory: &isDirectory)
        return fileExists && !isDirectory.boolValue
#else
        var isDirectory: Bool = false
        let fileExists: Bool = fm.fileExists(atPath: url.path, isDirectory: &isDirectory)
        return fileExists && !isDirectory
#endif
    }

    mutating func load(file: URL) -> Bool {
        let jsonDecoder: JSONDecoder = JSONDecoder()
        do {
            let data: Data = try Data.init(contentsOf: file)
            self = try jsonDecoder.decode(Self.self, from: data)
            return true
        }
        catch {
            print("Could not load from file '\(file.path)', reason: '\(error)")
            return false
        }
    }

    func save(file: URL) -> Bool {
        let jsonEncoder: JSONEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let json: Data = try jsonEncoder.encode(self)
            try json.write(to: file)
        }
        catch {
            return false
        }
        return true
    }
}
