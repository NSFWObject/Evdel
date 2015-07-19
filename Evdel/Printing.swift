//
//  PrintingManager.swift
//  Evdel
//
//  Created by Sash Zats on 7/18/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import AppKit


extension WindowController {
    @IBAction func print(sender: AnyObject) {
        if let controller = self.window?.contentViewController as? DiffViewController {
            controller.textView.becomeFirstResponder()
            let print = NSPrintOperation(view: controller.textView)
            print.runOperation()
        }

    }
}