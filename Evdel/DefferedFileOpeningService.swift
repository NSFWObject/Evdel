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
    
    public var deferredPaths: [String]? {
        didSet {
            if let openHandler = openHandler {
                openHandler(self)
            }
        }
    }
    
}