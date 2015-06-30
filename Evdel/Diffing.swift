//
//  Diffing.swift
//  Evdel
//
//  Created by Sash Zats on 6/29/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Foundation


protocol Diffable {
    func toDiff() -> Diff
}

public struct Diff {
    public enum DiffType {
        case Deletion, Insertion, None
    }
    
    public let type: DiffType
    public let text: String
}

extension Diff: Equatable, Hashable {
    public var hashValue: Int {
        return self.type.hashValue ^ self.text.hashValue
    }
}

public func == (lhs: Diff, rhs: Diff) -> Bool {
    return lhs.type == rhs.type && lhs.text == rhs.text
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
