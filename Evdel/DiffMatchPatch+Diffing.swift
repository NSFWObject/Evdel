//
//  DiffMatchPatch+Diffing.swift
//  Evdel
//
//  Created by Sash Zats on 6/29/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Foundation
import DiffMatchPatch

extension DMPOperation {
    public func toType() -> Diff.DiffType {
        switch self {
        case .Delete:
            return .Deletion
        case .Insert:
            return .Insertion
        case .Equal:
            return .None
        }
    }
}

extension DMPDiff: Diffable {
    public func toDiff() -> Diff {
        return Diff(type: self.operation.toType(), text: self.text)
    }
}
