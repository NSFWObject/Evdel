//
//  DiffPostprocessingPluginsTests.swift
//  Evdel
//
//  Created by Sash Zats on 7/2/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import EvdelKit
import Quick
import Nimble


class CombineDeletionInsertionPluginSpec: QuickSpec {
    override func spec() {
        describe("Combine Oposite Diff Types plugin") {
            var plugin: CombineDeletionInsertionPlugin!
            beforeEach {
                plugin = CombineDeletionInsertionPlugin()
            }
            
            describe("Deletion Insertion") {
                describe("fully matching diffs replaced with 1 no-op diff") {
                    /**
                      xxx
                    - aaa
                    + aaa
                      yyy
                     */
                    let diffs = [
                        Diff(type: .None, text: "xxx"),
                        Diff(type: .Deletion, text: "aaa"),
                        Diff(type: .Insertion, text: "aaa"),
                        Diff(type: .None, text: "yyy"),
                    ]
                    let resultDiffs = plugin.process(diffs)
                    expect(resultDiffs.count) == 3
                    expect(resultDiffs) == [
                        Diff(type: .None, text: "xxx"),
                        Diff(type: .None, text: "aaa"),
                        Diff(type: .None, text: "yyy"),
                    ]
                }
                
                describe("partially matching diffs turn into 3 diffs") {
                    /**
                      xxx
                    - bbaaa
                    + aaabb
                      yyy
                     */
                    let diffs = [
                        Diff(type: .None, text: "xxx"),
                        Diff(type: .Deletion, text: "bbaaa"),
                        Diff(type: .Insertion, text: "aaabb"),
                        Diff(type: .None, text: "yyy"),
                    ]
                    let resultDiffs = plugin.process(diffs)
                    expect(resultDiffs.count) == 5
                    expect(resultDiffs) == [
                        Diff(type: .None, text: "xxx"),
                        Diff(type: .Deletion, text: "bb"),
                        Diff(type: .None, text: "aaa"),
                        Diff(type: .Insertion, text: "bb"),
                        Diff(type: .None, text: "yyy"),
                    ]
                }

                describe("partially matching assymetrical diffs turn into 2 diffs") {
                    /**
                      xxx
                    - bbaaa
                    + aaa
                      yyy
                    */
                    let diffs = [
                        Diff(type: .None, text: "xxx"),
                        Diff(type: .Deletion, text: "bbaaa"),
                        Diff(type: .Insertion, text: "aaa"),
                        Diff(type: .None, text: "yyy"),
                    ]
                    let resultDiffs = plugin.process(diffs)
                    expect(resultDiffs.count) == 4
                    expect(resultDiffs) == [
                        Diff(type: .None, text: "xxx"),
                        Diff(type: .Deletion, text: "bb"),
                        Diff(type: .None, text: "aaa"),
                        Diff(type: .None, text: "yyy"),
                    ]
                }
                
                describe("not matching assymetrical diffs stay unchanged") {
                    /**
                      xxx
                    - bbaaa
                    + aaa
                      yyy
                    */
                    let diffs = [
                        Diff(type: .None, text: "xxx"),
                        Diff(type: .Deletion, text: "bbb"),
                        Diff(type: .Insertion, text: "aaa"),
                        Diff(type: .None, text: "yyy"),
                    ]
                    let resultDiffs = plugin.process(diffs)
                    expect(resultDiffs.count) == 4
                    expect(resultDiffs) == [
                        Diff(type: .None, text: "xxx"),
                        Diff(type: .Deletion, text: "bbb"),
                        Diff(type: .Insertion, text: "aaa"),
                        Diff(type: .None, text: "yyy"),
                    ]
                }
            }
            
            describe("Insertion Deletion") {
                describe("fully matched diffes implode") {
                    /**
                        xxx
                      + aaa
                      - aaa
                        yyy
                     */
                    let diffs = [
                        Diff(type: .None, text: "xxx"),
                        Diff(type: .Deletion, text: "aaa"),
                        Diff(type: .Insertion, text: "aaa"),
                        Diff(type: .None, text: "yyy"),
                    ]
                    let resultDiffs = plugin.process(diffs)
                    expect(resultDiffs.count) == 2
                    expect(resultDiffs) == [
                        Diff(type: .None, text: "xxx"),
                        Diff(type: .None, text: "yyy"),
                    ]
                }
                
            }
        }
    }
}
