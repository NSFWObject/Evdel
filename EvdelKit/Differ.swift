//
//  DiffService.swift
//  Evdel
//
//  Created by Sash Zats on 6/21/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Foundation
import DiffMatchPatch

public class Differ {

    public init() {
    }
    
    public func diff(left left: String, right: String, plugin: DiffPlugin = DiffMatchPatchPlugin()) -> [Diff] {
        let diffs: [Diff]
        do {
            diffs = try plugin.diff(left: left, right: right)
        } catch is DiffPluginError {
            diffs = []
        } catch {
            diffs = []
        }
        return diffs
    }
}
