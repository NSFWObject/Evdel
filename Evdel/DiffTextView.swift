//
//  DiffTextView.swift
//  Evdel
//
//  Created by Sash Zats on 6/25/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import AppKit

public class DiffTextView: NSTextView {
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setFontSize(12)
        lnv_setUpLineNumberView()
    }

}

// MARK: Fonts & Styling
extension DiffTextView {

    public var lineBreakMode: NSLineBreakMode {
        set {
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineBreakMode = newValue
            setAttribute(NSParagraphStyleAttributeName, value: paragraph)
        }
        get {
            if let paragraph = textStorage!.attribute(NSParagraphStyleAttributeName, atIndex: 0, effectiveRange: nil) as? NSParagraphStyle {
                return paragraph.lineBreakMode
            }
            return .ByWordWrapping
        }
    }
    
    public func makeFontLarger() {
        if let fontSize = textStorage?.font?.pointSize {
            setFontSize(fontSize + 1)
        }
    }
    
    public func makeFontSmaller() {
        if let fontSize = textStorage?.font?.pointSize {
            setFontSize(fontSize - 1)
        }
    }
    
    func setAttribute(name: String, value: AnyObject) {
        textStorage!.addAttribute(name, value: value, range: NSRange(location: 0, length: textStorage!.length))
    }
    
    // MARK: - Private
    
    private func setFontSize(fontSize: CGFloat) {        
        let font = textStorage!.attribute(NSFontAttributeName, atIndex: 0, effectiveRange: nil) as! NSFont
        let newFont = NSFont(name:font.fontName, size: fontSize)!
        self.font = newFont
        setAttribute(NSFontAttributeName, value: newFont)
    }
}
