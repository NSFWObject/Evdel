//
//  WindowController.swift
//  Evdel
//
//  Created by Sash Zats on 6/21/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import AppKit

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
        guard let controller = self.contentViewController as? DiffViewController

else {
            assertionFailure("No Controller found!")
            return
        }
        
        guard let fileMode = FileMode(rawValue: sender.selectedSegment) else {
            assertionFailure("Unexpected segment \(sender.selectedSegment)")
            return
        }
        switch fileMode {
        case .Left:
            controller.fileMode = [.Equal, .Delete]
        case .Both:
            controller.fileMode = [.Equal, .Delete, .Insert]
        case .Right:
            controller.fileMode = [.Equal, .Insert]
        }
    }
}