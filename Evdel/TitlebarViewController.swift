//
//  TitlebarViewController.swift
//  Evdel
//
//  Created by Sash Zats on 6/21/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import AppKit


class TitlebarViewController: NSTitlebarAccessoryViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutAttribute = .Bottom
    }
}