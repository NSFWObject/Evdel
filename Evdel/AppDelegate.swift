//
//  AppDelegate.swift
//  Evdel
//
//  Created by Sash Zats on 6/20/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Cocoa

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
        NSApp.activateIgnoringOtherApps(true)
        
        processCommandLineArguments()
        setMenuReference()
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
    
    func application(sender: NSApplication, openFiles filenames: [String]) {
        log("application:openFiles: \(filenames)")
        if filenames.count != 2 {
            NSApp.replyToOpenOrPrint(.Failure)
            return
        }
        FileOpeningService.sharedInstance.deferredPaths = filenames
        print("FileOpeningService.sharedInstance \(FileOpeningService.sharedInstance.deferredPaths)")
        NSApp.replyToOpenOrPrint(.Success)
    }
    
    private func processCommandLineArguments() {
        let arguments = NSProcessInfo.processInfo().arguments
        log("Opening files from command line arguments: \(arguments)")
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

