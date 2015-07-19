//
//  FileOpeningService.swift
//  Evdel
//
//  Created by Sash Zats on 6/30/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Foundation

public class FileOpeningService {

    public static let sharedInstance: FileOpeningService = FileOpeningService()

    public var openHandler: ((FileOpeningService) -> Void)?
    
    public var isBusy: Bool {
        get {
            return deferredPaths != nil
        }
    }
    
    private var _deferredPaths: [String]?
    public var deferredPaths: [String]? {
        set {
            if self.isBusy {
                return
            }
            _deferredPaths = newValue
        }
        get {
            return _deferredPaths
        }
//        didSet {
//            log("Want to open \(deferredPaths)")
//            if deferredPaths != nil {
//                if let openHandler = openHandler {
//                    openHandler(self)
//                }
//            }
//        }
    }
        
    private func isFileExist(URL: NSURL, workingDirectory: NSURL) -> NSURL? {
        if isFileExist(URL) {
            return URL
        }
        if let path = URL.relativePath  {
            let absoluteURL = workingDirectory.URLByAppendingPathComponent(path)
            return isFileExist(absoluteURL) ? absoluteURL : nil
        }
        return nil
    }
    
    private func isFileExist(URL: NSURL) -> Bool {
        if let path = URL.relativePath  {
            var isDirectory: ObjCBool = false
            if !NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDirectory) {
                return false
            }
            if isDirectory {
                return false
            }
            return true
        }
        return false
    }
    
    private func isValidDirectoryWithPWD(arg: String, pwd: String) -> String? {
        return nil
    }
}