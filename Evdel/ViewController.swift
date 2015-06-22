//
//  ViewController.swift
//  Evdel
//
//  Created by Sash Zats on 6/20/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Cocoa
import DiffMatchPatch

class ViewController: NSViewController {
    
    let DiffAttachmentAttributeName = "DiffAttachmentAttributeName"
    
    let diffService: DiffService = DiffService()
    @IBOutlet var textView: NSTextView!
    
    var fileMode: [DMPOperation] = [.Insert, .Equal, .Delete] {
        didSet {
            reloadDiff()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadDiff()
    }
    
    // MARK: - Private    
    
    private func reloadDiff() {
        let arguments = NSProcessInfo.processInfo().arguments
        if arguments.count < 3 {
            assertionFailure("Too few arguments! Expected at least 3, got \(arguments.count)")
            return
        }
        
        
        
        if let diffs = diffsForFilePair(leftPath: arguments[1], rightPath: arguments[2]) {
            displayDiffs(diffs, allowedOperations: fileMode)
        }
    }
    
    private func displayDiffs(diffs: [DMPDiff], allowedOperations: [DMPOperation]) {
        let attributedString = NSMutableAttributedString()
        for diff in diffs {
            if allowedOperations.contains({ $0 == diff.operation }) {
                attributedString.appendAttributedString(attributedStringForDiff(diff))
            }
        }

        let globalAttributes = [
            NSFontAttributeName: NSFont(name: "Menlo", size: 10)!,
        ]
        let range = NSRange(location:0, length: attributedString.length)
        attributedString.addAttributes(globalAttributes, range: range)
        
        textView.textStorage?.setAttributedString(attributedString)
    }
    
    private func attributedStringForDiff(diff: DMPDiff) -> NSAttributedString {
        var attributes: [String: AnyObject] = [DiffAttachmentAttributeName: diff]
        switch diff.operation {
        case .Insert:
            attributes[NSBackgroundColorAttributeName] = NSColor(calibratedRed:0.86, green:0.959, blue:0.807, alpha:1)
        case .Delete:
            attributes[NSBackgroundColorAttributeName] = NSColor(calibratedRed:0.999, green:0.878, blue:0.856, alpha:1)
        default:
            break
        }
        return NSAttributedString(string: diff.text, attributes: attributes)
    }
    
    private func diffsForFilePair(leftPath leftPath: String, rightPath: String) -> [DMPDiff]? {
        guard let left = string(path: leftPath), right = string(path: rightPath) else {
            return nil
        }
        return diffService.diff(left: left, right: right)
    }
    
    private func string(path path: String) -> String? {
        do {
            return try String(contentsOfFile: path)
        } catch (let e) {
            print(e)
            return nil
        }
    }

}
