//
//  DiffMatchPatchPlugin.swift
//  Evdel
//
//  Created by Sash Zats on 7/2/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Foundation
import DiffMatchPatch

public class DiffMatchPatchPlugin: DiffPlugin {
    private let engine: DiffMatchPatch = DiffMatchPatch()
    
    public func diff(left left: String, right: String) throws -> [Diff] {
        let dmpResult = engine.diff_mainOfOldString(left, andNewString: right)
        if dmpResult == nil {
            throw DiffPluginError.Unknown
        }
        engine.diff_cleanupSemantic(dmpResult)
        engine.diff_cleanupEfficiency(dmpResult)
        engine.diff_cleanupMerge(dmpResult)
        let dmpDiffs = ((dmpResult as NSArray) as! [DMPDiff])
        return dmpDiffs.map{ $0.toDiff() }
    }
}

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
