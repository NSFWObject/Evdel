//
//  Diffing.swift
//  Evdel
//
//  Created by Sash Zats on 6/29/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Foundation


/**
    Implementation agnostic diff. Any plugin's results should be
    converted to `Diff`s before continue to postprocessing
 */
public struct Diff {
    /**
        Change types
     */
    public enum DiffType: String {
        case Deletion = "Deletion"
        case Insertion = "Insertion"
        case None = "None"
    }
    
    public let type: DiffType
    public let text: String
    
    public init(type: DiffType, text: String) {
        self.type = type
        self.text = text
    }
}

extension Diff: Equatable, Hashable {
    public var hashValue: Int {
        return self.type.hashValue ^ self.text.hashValue
    }
}


public func == (lhs: Diff, rhs: Diff) -> Bool {
    return lhs.type == rhs.type && lhs.text == rhs.text
}


/**
    Concrete implementation of a plugin based on an existent engine, 
    e.g. diff match patch plugin or git plugin
 */
public protocol DiffPlugin {  
    func diff(left left: String, right: String) -> [Diff]
}

protocol ErrorType {
    
}

public enum DiffPluginError: ErrorType {
    case Unknown
}


/**
    `Diff`s posprocessing, should be applicable to any `DiffPlugin` results
 */
public protocol DiffPostprocessingPlugin {
    func process(diffs: [Diff]) -> [Diff]
}


public protocol Diffable {
    func toDiff() -> Diff
}


 extension Diff: DebugPrintable {
    public var debugDescription: String {
        switch type {
        case .Insertion:
            return "+\(text)"
        case .Deletion:
            return "-\(text)"
        case .None:
            return "=\(text)"
        }
    }
}


// Compatibility with Cocoa
public class DiffObject: NSObject {
    public let diff: Diff
    
    required public init(diff: Diff) {
        self.diff = diff
    }
    
    override init() {
        fatalError("Use init(diff:)")
    }
}
