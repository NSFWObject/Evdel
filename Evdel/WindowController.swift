//
//  WindowController.swift
//  Evdel
//
//  Created by Sash Zats on 6/21/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import AppKit
import QuartzCore


private enum FileMode: Int {
    case Left = 0
    case Both = 1
    case Right = 2
}

class WindowController: NSWindowController {

    override func windowDidLoad() {
        guard let window = self.window else {
            assertionFailure("Expected to have a window by now")
            return
        }
        
        window.titleVisibility = .Hidden
    }

    @IBAction func fileModeSegmentedControlAction(sender: NSSegmentedControl) {
        guard let controller = self.contentViewController as? DiffViewController else {
            assertionFailure("No Controller found!")
            return
        }
        
        guard let fileMode = FileMode(rawValue: sender.selectedSegment) else {
            assertionFailure("Unexpected segment \(sender.selectedSegment)")
            return
        }
        switch fileMode {
        case .Left:
            controller.fileMode = [.None, .Deletion]
        case .Both:
            controller.fileMode = [.None, .Deletion, .Insertion]
        case .Right:
            controller.fileMode = [.None, .Insertion]
        }
    }
}


extension WindowController: NSOpenSavePanelDelegate {
    @IBAction func openDocument(file: AnyObject) {
        let open = NSOpenPanel()
        open.allowsMultipleSelection = true
        open.delegate = self
//        open.title = "Please select a pair of files to diff"
        open.beginWithCompletionHandler { (status) in
            if status != NSFileHandlingPanelOKButton {
                return
            }
            guard open.URLs.count == 2 else {
                return
            }
            guard let controller = self.contentViewController as? DiffViewController else {
                return
            }
            controller.openDiff(leftPath: open.URLs[0].relativePath!, rightPath: open.URLs[1].relativePath!)
        }
    }
   
}