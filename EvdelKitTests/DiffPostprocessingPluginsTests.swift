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
        var plugin: CombineDeletionInsertionPlugin!
        describe("Combine Oposite Diff Types plugin") {
            beforeEach {
                plugin = CombineDeletionInsertionPlugin()
            }
            
            describe("Deletion Insertion") {
                it("fully matching diffs replaced with 1 no-op diff") {
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
                    expect(resultDiffs) == [
                        Diff(type: .None, text: "xxx"),
                        Diff(type: .None, text: "aaa"),
                        Diff(type: .None, text: "yyy"),
                    ]
                }
                
                it("should match the longest sequence") {
                    /**
                      xxx
                    - xxbbaaa
                    + bbaaayy
                      yyy
                     */
                    let diffs = [
                        Diff(type: .None, text: "xxx"),
                        Diff(type: .Deletion, text: "xxbbaaa"),
                        Diff(type: .Insertion, text: "bbaaayy"),
                        Diff(type: .None, text: "yyy"),
                    ]
                    let resultDiffs = plugin.process(diffs)
                    expect(resultDiffs) == [
                        Diff(type: .None, text: "xxx"),
                        Diff(type: .Deletion, text: "xx"),
                        Diff(type: .None, text: "bbaaa"),
                        Diff(type: .Insertion, text: "yy"),
                        Diff(type: .None, text: "yyy"),
                    ]
                    
                }
                
                it("partially matching diffs turn into 3 diffs") {
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
                    expect(resultDiffs) == [
                        Diff(type: .None, text: "xxx"),
                        Diff(type: .Deletion, text: "bb"),
                        Diff(type: .None, text: "aaa"),
                        Diff(type: .Insertion, text: "bb"),
                        Diff(type: .None, text: "yyy"),
                    ]
                }

                it("partially matching assymetrical diffs turn into 2 diffs") {
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
                    expect(resultDiffs) == [
                        Diff(type: .None, text: "xxx"),
                        Diff(type: .Deletion, text: "bb"),
                        Diff(type: .None, text: "aaa"),
                        Diff(type: .None, text: "yyy"),
                    ]
                }
                
                it("not matching assymetrical diffs stay unchanged") {
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
                    expect(resultDiffs) == [
                        Diff(type: .None, text: "xxx"),
                        Diff(type: .Deletion, text: "bbb"),
                        Diff(type: .Insertion, text: "aaa"),
                        Diff(type: .None, text: "yyy"),
                    ]
                }
            }
            
            context("Insertion Deletion") {
                it("fully matched diffs implode") {
                    /**
                        xxx
                      + aaa
                      - aaa
                        yyy
                     */
                    let diffs = [
                        Diff(type: .None, text: "xxx"),
                        Diff(type: .Insertion, text: "aaa"),
                        Diff(type: .Deletion, text: "aaa"),
                        Diff(type: .None, text: "yyy"),
                    ]
                    let resultDiffs = plugin.process(diffs)
                    expect(resultDiffs) == [
                        Diff(type: .None, text: "xxx"),
                        Diff(type: .None, text: "yyy"),
                    ]
                }
                
                it("partially matching diffs reduced to unequal parts") {
                    /**
                        xxx
                      + xxaaa
                      - aaayy
                        yyy
                     */
                    let diffs = [
                        Diff(type: .None, text: "xxx"),
                        Diff(type: .Insertion, text: "xxaaa"),
                        Diff(type: .Deletion, text: "aaayy"),
                        Diff(type: .None, text: "yyy"),
                    ]
                    let resultDiffs = plugin.process(diffs)
                    expect(resultDiffs) == [
                        Diff(type: .None, text: "xxx"),
                        Diff(type: .Insertion, text: "xx"),
                        Diff(type: .Deletion, text: "yy"),
                        Diff(type: .None, text: "yyy"),
                    ]
                    
                }
            }
        }
    }
}
