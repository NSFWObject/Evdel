//
//  DiffViewController.swift
//  Evdel
//
//  Created by Sash Zats on 6/20/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Cocoa


class DiffViewController: NSViewController {
    
    let DiffAttachmentAttributeName = "DiffAttachmentAttributeName"
    
    @IBOutlet var textView: NSTextView!
    @IBOutlet weak var textScrollView: NSScrollView!

    let diffService: DiffService = DiffService()
    
    var fileMode: [Diff.DiffType] = [.Insertion, .None, .Deletion] {
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
        print("\n\(arguments)\n")
        if arguments.count < 5 {
            assertionFailure("Too few arguments! Expected at least 3, got \(arguments.count)")
            return
        }
        
        let leftPath = arguments[3]
        let rightPath = arguments[4]
        print("Opening \(leftPath) \(rightPath)")
        if let diffs = diffsForFilePair(leftPath: leftPath, rightPath: rightPath) {
            displayDiffs(diffs, allowedOperations: fileMode)
        }
    }
    
    private func displayDiffs(diffs: [Diff], allowedOperations: [Diff.DiffType]) {
        let attributedString = NSMutableAttributedString()
        for diff in diffs {
            if allowedOperations.contains({ $0 == diff.type }) {
                attributedString.appendAttributedString(attributedStringForDiff(diff))
            }
        }

        let globalAttributes = [
            NSFontAttributeName: textView.font!,
            NSForegroundColorAttributeName: NSColor.grayColor()
        ]
        let range = NSRange(location:0, length: attributedString.length)
        attributedString.addAttributes(globalAttributes, range: range)
        textView.textStorage?.setAttributedString(attributedString)
    }
    
    private func attributedStringForDiff(diff: Diff) -> NSAttributedString {
        var attributes: [String: AnyObject] = [DiffAttachmentAttributeName: DiffObject(diff: diff)]
        switch diff.type {
        case .Insertion:
            attributes[NSBackgroundColorAttributeName] = NSColor(calibratedRed:0.86, green:0.959, blue:0.807, alpha:1)
        case .Deletion:
            attributes[NSBackgroundColorAttributeName] = NSColor(calibratedRed:0.999, green:0.878, blue:0.856, alpha:1)
        default:
            break
        }
        return NSAttributedString(string: diff.text, attributes: attributes)
    }
    
    private func diffsForFilePair(leftPath leftPath: String, rightPath: String) -> [Diff]? {
        guard let left = string(path: leftPath), right = string(path: rightPath) else {
            return nil
        }
        return diffService.diff(left: left, right: right, options: [DiffOptions.EndOfOneDiffIsBeginningOfAnother])
    }
    
    private func string(path path: String) -> String? {
        let manager = NSFileManager.defaultManager()
        var isDirectory: ObjCBool = false
        if !manager.fileExistsAtPath(path, isDirectory: &isDirectory) || isDirectory {
            return nil
        }
        do {
            return try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        } catch (let e) {
            print("Failed to read the string from \(path): \(e)")
            return nil
        }
    }

}

extension DiffViewController {

    @IBAction func makeTextSmaller(sender: AnyObject) {
//        textView.makeFontSmaller()
    }
    
    @IBAction func makeTextLarger(sender: AnyObject) {
//        textView.makeFontLarger()
    }

    @IBAction func toggleWordWrap(sender: NSMenuItem) {
        let wordWrappingEnabled = sender.state == NSOffState
        sender.state = wordWrappingEnabled ? NSOnState : NSOffState
//        textView.lineBreakMode = wordWrappingEnabled ? NSLineBreakMode.ByWordWrapping : NSLineBreakMode.ByClipping
    }
}
