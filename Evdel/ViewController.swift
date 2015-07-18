//
//  DiffViewController.swift
//  Evdel
//
//  Created by Sash Zats on 6/20/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Cocoa
import EvdelKit

class DiffViewController: NSViewController {
    
    let DiffAttachmentAttributeName = "DiffAttachmentAttributeName"
    
    @IBOutlet var textView: NSTextView!
    @IBOutlet weak var textScrollView: NSScrollView!

    let diffService: Differ = Differ()
    
    var fileMode: [Diff.DiffType] = [.Insertion, .None, .Deletion] {
        didSet {
            reloadDiff()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextView()
        setupNotificationHandler()
        reloadDiff()
    }
    
    // MARK: - Public 
    
    func openDiff(leftPath leftPath: NSURL, rightPath: NSURL) {
        if let diffs = diffsForFilePair(leftPath: leftPath, rightPath: rightPath) {
            displayDiffs(diffs, allowedOperations: fileMode)
        }
    }
    
    
    // MARK: - Private
    
    func setupNotificationHandler() {
        // File did open
        NSNotificationCenter.defaultCenter().addObserverForName(FileOpeningManagerShouldOpenFilesNotification, object: nil, queue: nil) { [unowned self] note in
            if let userInfo = note.userInfo, left = userInfo[FileOpeningManagerLeftFileKey] as? NSURL, right = userInfo[FileOpeningManagerRightFileKey] as? NSURL {
                self.openDiff(leftPath: left, rightPath: right)
            }
        }
        
        // View mode did change
        NSNotificationCenter.defaultCenter().addObserverForName(ViewModeManagerDidChangeModeNotification, object: nil, queue: nil) { [unowned self] _ in
            switch ViewModeManager.sharedManager.mode {
            case .Left:
                self.fileMode = [.Deletion, .None]
            case .Both:
                self.fileMode = [.Deletion, .None, .Insertion]
            case .Right:
                self.fileMode = [.Insertion, .None]
            }
        }
    }

    // MARK: - Private
    
    private func setupTextView() {
        textScrollView.contentInsets = NSEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        textView.textContainer!.widthTracksTextView = true
        textView.textContainer!.containerSize = NSSize(width: 320.0, height:Double(FLT_MAX))

        let textContainer = NSTextContainer()
        textView.replaceTextContainer(textContainer)
        textContainer.replaceLayoutManager(DiffLayoutManager())        
    }
    
    private func reloadDiff() {
        
        if let left = FileOpeningManager.sharedInstance.leftFile, right = FileOpeningManager.sharedInstance.rightFile {
            openDiff(leftPath: left, rightPath: right)
        }
    }
    
    private func displayDiffs(diffs: [Diff], allowedOperations: [Diff.DiffType]) {
        let attributedString = NSMutableAttributedString()
        for diff in diffs {
            if allowedOperations.contains({ $0 == diff.type }) {
                attributedString.appendAttributedString(attributedStringForDiff(diff))
            }
        }

        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = NSLineBreakMode.ByWordWrapping
        let globalAttributes = [
            NSFontAttributeName: textView.font!,
            NSForegroundColorAttributeName: NSColor.grayColor(),
            NSParagraphStyleAttributeName: paragraph
        ]
        let range = NSRange(location:0, length: attributedString.length)
        attributedString.addAttributes(globalAttributes, range: range)
        textView.textStorage?.setAttributedString(attributedString)
    }
    
    private func attributedStringForDiff(diff: Diff) -> NSAttributedString {
        let attributes: [String: AnyObject] = [DiffTypeAttributeName: diff.type.rawValue]
        return NSAttributedString(string: diff.text, attributes: attributes)
    }
    
    private func diffsForFilePair(leftPath leftPath: NSURL, rightPath: NSURL) -> [Diff]? {
        guard let left = string(path: leftPath), right = string(path: rightPath) else {
            return nil
        }
        return diffService.diff(left: left, right: right)
    }
    
    private func pathsFromArguments(arguments: [String]) -> [String]? {
        if arguments.count < 3 {
            return nil
        }

        if let left = reachablePathForPath(arguments[1], pwd: arguments[3]),
               right = reachablePathForPath(arguments[2], pwd: arguments[3]) {
            return [left, right]
        }
        return nil
    }
    
    private func reachablePathForPath(path: String, pwd: String?) -> String? {
        let manager = NSFileManager.defaultManager()
        if manager.fileExistsAtPath(path) {
            return path
        }
        guard let pwd = pwd else {
            return nil
        }
        let result = pwd + path
        if manager.fileExistsAtPath(result) {
            return result
        }
        return nil
    }
    
    private func string(path URL: NSURL) -> String? {
        do {
            try URL.checkResourceIsReachable()
        } catch (_) {
            return nil
        }
        do {
            let string = try String(contentsOfURL: URL, encoding: NSUTF8StringEncoding)
            return string
        } catch (_) {
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
