//
//  main.swift
//  CLI
//
//  Created by Sash Zats on 7/12/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Foundation
import AppKit

class EvdelKatan {
    private lazy var pwd: String! = NSProcessInfo.processInfo().environment["PWD"]!

    func run() {
        guard let appURL = evdelURL() else {
            failWithMessage("Can't find Evdel-Rosh")
        }
        
        guard pwd != nil else {
            failWithMessage("No PWD \(NSProcessInfo.processInfo().environment)")
        }
        
        let process = NSProcessInfo.processInfo()
        guard process.arguments.count >= 3 else {
            failWithMessage("Not enough arguments")
        }
        
        guard let left = fullPathFromArgument(process.arguments[1]) else {
            failWithMessage("File at \(process.arguments[1]) can not be resolved")
        }
        
        guard let right = fullPathFromArgument(process.arguments[2]) else {
            failWithMessage("File at \(process.arguments[2]) can not be resolved")
        }
        
        launchAppAtURL(appURL, left: left, right: right)
    }
    
    private func launchAppAtURL(URL: NSURL, left: NSURL, right: NSURL) {
        do {
            try NSWorkspace.sharedWorkspace().launchApplicationAtURL(URL, options: NSWorkspaceLaunchOptions.Async, configuration: [NSWorkspaceLaunchConfigurationArguments: [left.absoluteString, right.absoluteString]])
        } catch (let e) {
            failWithMessage("Failed to launch \(e)")
        }
    }
    
    private func fullPathFromArgument(argumentPath: String) -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(argumentPath) {
            return NSURL(fileURLWithPath: argumentPath)
        }
        let fullPath = pwd.stringByAppendingPathComponent(argumentPath)
        if fileManager.fileExistsAtPath(fullPath) {
            return NSURL(fileURLWithPath: fullPath)
        }
        return nil
    }

    private func evdelURL() -> NSURL? {
        for app in NSWorkspace.sharedWorkspace().runningApplications {
            if let bundleId = app.bundleIdentifier {
                if bundleId == "com.zats.Evdel" {
                    return app.bundleURL
                }
            }
        }
        
        func isEvdelAppAtURL(url: NSURL) -> Bool {
            guard let bundle = NSBundle(URL: url) else {
                return false
            }
            
            return bundle.bundleIdentifier == "com.zats.Evdel"
            
            // TODO: return when version info is in place
            guard let bundledVersion = bundle.objectForInfoDictionaryKey("EvdelKatanBundleVersion") as? String else {
                return false
            }
            
            guard let myVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("EvdelKatanBundleVersion") as? String else {
                return false
            }
            
            return bundledVersion == myVersion
        }
        
        let globalAppURL = NSURL(fileURLWithPath: "/Applications/Evdel.app")
        if isEvdelAppAtURL(globalAppURL) {
            return globalAppURL
        }
        
        let userAppURL = NSURL(fileURLWithPath: "~/Applications/Evdel.app".stringByExpandingTildeInPath)
        if isEvdelAppAtURL(userAppURL) {
            return userAppURL
        }
        
        return nil
    }
}

@noreturn private func failWithMessage(string: String) {
    #if DEBUG
        fatalError(string)
    #else
        print(string)
        exit(EXIT_FAILURE)
    #endif
}

EvdelKatan().run()
