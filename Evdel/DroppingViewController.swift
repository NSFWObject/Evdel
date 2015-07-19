//
//  DroppingViewController.swift
//  Evdel
//
//  Created by Sash Zats on 7/18/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import AppKit

let DroppingViewControllerRequiresDiffNotification = "DroppingViewControllerRequiresDiffNotification"
let DroppingViewLeftURLKey = "DroppingViewLeftURLKey"
let DroppingViewRightURLKey = "DroppingViewRightURLKey"

class DroppingViewController: NSViewController {
    
    enum FileURL {
        case Left(url: NSURL?), Right(url: NSURL?)
        
        var URL: NSURL? {
            switch self {
            case .Left(let url):
                return url
            case .Right(let url):
                return url
            }
        }
        
        var hasURL: Bool {
            switch self {
            case .Left(let url):
                return url != nil
            case .Right(let url):
                return url != nil
            }
            
        }
    }

    private var leftURL: FileURL = .Left(url: nil)
    private var rightURL: FileURL = .Right(url: nil)

    @IBOutlet weak var leftButton: NSButton!
    @IBOutlet weak var rightButton: NSButton!
    @IBAction func _leftButtonAction(sender: AnyObject) {
        showOpenFile(self.leftURL)
    }

    @IBAction func _rightButtonAction(sender: AnyObject) {
        showOpenFile(self.rightURL)
    }
    
    private func showOpenFile(side: FileURL) {
        let url: NSURL?
        switch side {
        case .Left(let urll):
            url = urll
        case .Right(let urll):
            url = urll
        }

        let open = NSOpenPanel()
        open.directoryURL = url
        open.treatsFilePackagesAsDirectories = true
        open.beginWithCompletionHandler { (status) in
            if status != NSFileHandlingPanelOKButton {
                return
            }
            if let url = open.URL {
                let newSide: FileURL
                switch side {
                case .Left(_):
                    newSide = .Left(url: url)
                    self.leftURL = newSide
                case .Right(_):
                    newSide = .Right(url: url)
                    self.rightURL = newSide
                }
                self.updateButton(newSide)
                self.updateIsReadyForDiff()
            }
        }
    }
    
    private func updateIsReadyForDiff() {
        if let leftURL = self.leftURL.URL, rightURL = self.rightURL.URL {
            NSNotificationCenter.defaultCenter().postNotificationName(DroppingViewControllerRequiresDiffNotification, object: self, userInfo: [
                DroppingViewRightURLKey: rightURL,
                DroppingViewLeftURLKey: leftURL
            ])
        }
    }
    
    private func updateButton(fileURL: FileURL) {
        let button: NSButton
        let url: NSURL?
        let defaultTitle: String
        switch fileURL {
        case .Left(let urll):
            button = self.leftButton
            url = urll
            defaultTitle = "Left"
        case .Right(let urll):
            button = self.rightButton
            url = urll
            defaultTitle = "Right"
        }
        if let url = url {
            if let path = url.relativePath {
                button.title = path
            } else {
                button.title = defaultTitle
            }
        }
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.leftButton.attributedTitle = buttonAttributedStringForTitle("Open a File")
        self.rightButton.attributedTitle = buttonAttributedStringForTitle("Or Drop It")
    }
    
    private func buttonAttributedStringForTitle(title: String) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .CenterTextAlignment
        let attributedString = NSAttributedString(string: title, attributes: [
            NSParagraphStyleAttributeName: paragraph,
            NSForegroundColorAttributeName: NSColor.darkGrayColor()
        ])
        return attributedString
    }
}

class DropZoneButton: NSButton {
    override var wantsDefaultClipping: Bool {
        return false
    }
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        print(sender.draggingSource())
        return NSDragOperation.Every
    }
}

class DropZoneButtonCell: NSButtonCell {
    
    override func drawBezelWithFrame(frame: NSRect, inView controlView: NSView) {
        let cornerRadius: CGFloat = 4
        let bezier = NSBezierPath(roundedRect: frame, xRadius: cornerRadius, yRadius: cornerRadius)
        bezier.lineWidth = 1
        var dashes: [CGFloat] = [4, 2]
        bezier.setLineDash(&dashes, count: 2, phase: 0)
        NSColor.darkGrayColor().setStroke()
        bezier.stroke()
    }
}
