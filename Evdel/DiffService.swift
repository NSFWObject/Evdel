//
//  DiffService.swift
//  Evdel
//
//  Created by Sash Zats on 6/21/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Foundation
import DiffMatchPatch

public class DiffService {

    let engine: DiffMatchPatch = DiffMatchPatch()
    
    public func diff(left left: String, right: String) -> [DMPDiff] {
        let arr = engine.diff_mainOfOldString(left, andNewString: right)
        engine.diff_cleanupSemantic(arr)
        engine.diff_cleanupEfficiency(arr)
        return (arr as NSArray) as! [DMPDiff]
    }
}
