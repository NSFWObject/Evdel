//: Playground - noun: a place where people can play

import AppKit
import DiffMatchPatch


extension Diff {
    override public var description: String {
        let result: String = operation == DIFF_DELETE ? "×" : operation == DIFF_INSERT ? "+" : "="
        return "\(result) \(text)"
    }
    
    public var attributes: [String: AnyObject] {
        if operation == DIFF_DELETE {
            return [NSBackgroundColorAttributeName: NSColor.redColor()]
        } else if operation == DIFF_INSERT {
            return [NSBackgroundColorAttributeName: NSColor.greenColor()]
        }
        return [:]
    }
}


public class Differ {
    private let oldString: String
    private let newString: String
    
    private let engine: DiffMatchPatch
    
    public init(oldString: String, newString: String) {
        self.oldString = oldString
        self.newString = newString
        engine = DiffMatchPatch()
    }
    
    public func diffs() -> [Diff] {
        let diff = engine.diff_mainOfOldString(oldString, andNewString: newString)
        engine.diff_cleanupEfficiency(diff)
        engine.diff_cleanupSemantic(diff)
        var diffs = diff as! [Diff]
        
        return diffs
    }
}

let oldURL = NSBundle.mainBundle().URLForResource("old", withExtension: "h")!
let newURL = NSBundle.mainBundle().URLForResource("new", withExtension: "h")!
let old = try! String(contentsOfURL: oldURL)
let new = try! String(contentsOfURL: newURL)

let engine = Differ(oldString: old, newString: new)
let attrOld = NSMutableAttributedString()

for diff in engine.diffs() {
    attrOld.appendAttributedString(NSAttributedString(string: diff.text, attributes: diff.attributes))
}
attrOld.addAttribute(NSFontAttributeName, value: NSFont(name: "Menlo", size: 8)!, range: NSRange(location: 0, length: attrOld.length))


