//
//  WindowController.swift
//  Evdel
//
//  Created by Sash Zats on 6/21/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import AppKit
import QuartzCore


class WindowController: NSWindowController {

    @IBOutlet weak var viewModeSegmentedControl: NSSegmentedControl!
    var viewMenu: NSMenuItem!

    override func windowDidLoad() {
        guard let window = self.window else {
            assertionFailure("Expected to have a window by now")
            return
        }
        
        window.titleVisibility = .Hidden
    }
}

