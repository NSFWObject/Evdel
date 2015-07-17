//
//  DiffLayoutManager.swift
//  Evdel
//
//  Created by Sash Zats on 7/16/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import AppKit
import EvdelKit


let DiffTypeAttributeName = "DiffTypeAttributeName"


class DiffLayoutManager: NSLayoutManager {

    override func drawGlyphsForGlyphRange(glyphsToShow: NSRange, atPoint origin: NSPoint) {
        guard let textStorage = textStorage, textContainer = textContainers.first else {
            return
        }
        
        super.drawGlyphsForGlyphRange(glyphsToShow, atPoint: origin)

        textStorage.enumerateAttribute(DiffTypeAttributeName, inRange: glyphsToShow, options: NSAttributedStringEnumerationOptions.LongestEffectiveRangeNotRequired) { attribute, range, stop in
            guard let diffTypeString = attribute as? String, diffType = Diff.DiffType(rawValue: diffTypeString) else {
                return
            }
            guard diffType != .None else {
                return
            }
            NSGraphicsContext.saveGraphicsState()
            let backgroundColor: NSColor
            switch diffType {
            // compiler doesn't see guard above
            case .None:
                fatalError("Can't touch it")
            case .Insertion:
                backgroundColor = NSColor(red:0.882, green:0.994, blue:0.886, alpha:1)
            case .Deletion:
                backgroundColor = NSColor(red:1, green:0.894, blue:0.892, alpha:1)
            }
            backgroundColor.setFill()
            let boundingRect = self.boundingRectForGlyphRange(range, inTextContainer: textContainer)
            NSRectFill(boundingRect)
            super.drawGlyphsForGlyphRange(range, atPoint: origin)
            NSGraphicsContext.restoreGraphicsState()
        }
    }
}

extension String {
    var range: Range<Index> {
        return Range(start: self.startIndex, end: self.endIndex)
    }
}