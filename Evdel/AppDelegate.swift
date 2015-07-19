//
//  AppDelegate.swift
//  Evdel
//
//  Created by Sash Zats on 6/20/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Cocoa
import Fabric
import Crashlytics
import ParseOSX
import Bolts

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var viewMenu: NSMenuItem! {
        didSet {
        }
    }
    
    func applicationWillBecomeActive(notification: NSNotification) {

    }
    
    func applicationShouldHandleReopen(sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        return true
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        Fabric.with([Crashlytics()])
        Parse.setApplicationId("MIElOdZDocDFoVGmT4eNiQSIYhRyPklAuPOiVNqo", clientKey:"I9WrcpwyCUcwpCX6FNWPqZxHUqtxgKKOqJHUiiSV")

        NSApp.activateIgnoringOtherApps(true)
        setMenuReference()
        
        PFAnalytics.trackAppOpenedWithLaunchOptions(nil)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
    
    func application(sender: NSApplication, openFiles filenames: [String]) {
        if filenames.count != 2 {
            NSApp.replyToOpenOrPrint(.Failure)
            return
        }
        FileOpeningService.sharedInstance.deferredPaths = filenames
        NSApp.replyToOpenOrPrint(.Success)
    }
    
    private func processCommandLineArguments() {
        let arguments = NSProcessInfo.processInfo().arguments
        FileOpeningService.sharedInstance.handleArguments(arguments)
    }
    
    private func setMenuReference() {
        if let window = NSApp.keyWindow {
            if let controller = window.windowController as? WindowController {
                controller.viewMenu = viewMenu
            }
        }
    }
}

