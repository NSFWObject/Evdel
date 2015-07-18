//
//  FileOpeningHandler.swift
//  Evdel
//
//  Created by Sash Zats on 7/18/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import AppKit

public let FileOpeningManagerShouldOpenFilesNotification = "FileOpeningManagerShouldOpenFilesNotification"
public let FileOpeningManagerLeftFileKey = "FileOpeningManagerLeftFileKey"
public let FileOpeningManagerRightFileKey = "FileOpeningManagerRightFileKey"

public let FileOpeningManagerDidOpenSignleFileNotification = "FileOpeningManagerDidOpenSignleFileNotification"


private enum Side {
    case Left, Right
}


public class FileOpeningManager {
    public static var sharedInstance = FileOpeningManager()

    public var leftFile: NSURL? {
        didSet {
            notifyIfNeeded(.Left)
        }
    }

    public var rightFile: NSURL? {
        didSet {
            notifyIfNeeded(.Right)
        }
    }
    
    private func notifyIfNeeded(side: Side) {
        var userInfo: [String: NSURL] = [:]
        if let left = leftFile {
            userInfo[FileOpeningManagerLeftFileKey] = left
        }
        if let right = rightFile {
            userInfo[FileOpeningManagerRightFileKey] = right
        }
        NSNotificationCenter.defaultCenter().postNotificationName(FileOpeningManagerShouldOpenFilesNotification,
            object: nil,
            userInfo: userInfo)
    }
}


extension WindowController {
    
    
    @IBAction func openLeftFile(sender: AnyObject) {
        showFileOpen(side: .Left)
    }
    
    @IBAction func openRightFile(sender: AnyObject) {
        showFileOpen(side: .Right)
    }
    
    private func showFileOpen(side side: Side) {
        let manager = FileOpeningManager.sharedInstance
        let URL: NSURL?
        switch side {
        case .Left:
            URL = manager.leftFile
        case .Right:
            URL = manager.rightFile
        }
        
        let open = NSOpenPanel()
        open.directoryURL = URL
        open.treatsFilePackagesAsDirectories = true
        open.beginWithCompletionHandler{ handler in
            if handler != NSFileHandlingPanelOKButton {
                return
            }
            guard let URL = open.URL else {
                return
            }
            switch side {
            case .Left:
                manager.leftFile = URL
            case .Right:
                manager.rightFile = URL
            }
        }
    }
    
}