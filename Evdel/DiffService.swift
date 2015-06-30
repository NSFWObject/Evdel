//
//  DiffService.swift
//  Evdel
//
//  Created by Sash Zats on 6/21/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Foundation
import DiffMatchPatch

public struct DiffOptions: OptionSetType {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    static let EndOfOneDiffIsBeginningOfAnother = DiffOptions(rawValue: 1)

    static let PreferAdditionAtBottom = DiffOptions(rawValue: 2)
}

public class DiffService {

    let engine: DiffMatchPatch = DiffMatchPatch()
    
    public func diff(left left: String, right: String, options: DiffOptions? = nil) -> [Diff] {
        let arr = engine.diff_mainOfOldString(left, andNewString: right)
        engine.diff_cleanupEfficiency(arr)
        engine.diff_cleanupSemantic(arr)
        engine.diff_cleanupMerge(arr)
        var result = (arr as NSArray) as! [DMPDiff]
        if let options = options {
            if options.contains(DiffOptions.EndOfOneDiffIsBeginningOfAnother) {
                result = DiffMatchPatch.cleanupAdjustentDuplicateDiffParts(result)
            }
            if options.contains(DiffOptions.PreferAdditionAtBottom) {
                result = DiffMatchPatch.commonInsertionBubblesDown(result)
            }
        }
        return result.map{$0.toDiff()}
    }
}

extension DiffMatchPatch {
    /*
    Converts
    
    ```
      xxxxxx
    + aaaaaa
    + bbbbbb
    + cccccc
      aaaaaa
      xxxxxx
    ```
    
    into

    ```
      xxxxxx
      aaaaaa
    + bbbbbb
    + cccccc
    + aaaaaa
      xxxxxx
    ```
    
    Since insertion is most likely to happen in the bottom
    */
    public static func commonInsertionBubblesDown(diffs: [DMPDiff]) -> [DMPDiff] {
        if diffs.count < 2 {
            return diffs
        }
        
        var result = diffs
        for i in 0..<result.count-1 {
            let diff1 = result[i]
            for j: Int in i+1..<result.count {
                let diff2 = result[j]
                if !(diff1.operation == .Insert && diff2.operation == .Equal) {
                    continue
                }
                let commonString = diff1.text.commonPrefixWithString(diff2.text, options: NSStringCompareOptions(rawValue:0))
                if commonString.characters.count > 0 {
                    diff2.text! += commonString
                }
            }
        }
        return result
    }
    
    private static func commonPrefix(string1 str1: String, string2 str2: String) -> Int? {
        let length = min(str1.lengthOfBytesUsingEncoding(NSUTF8StringEncoding), str2.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        var index1 = str1.startIndex, index2 = str2.startIndex
        for i in 0..<length {
            if str1.characters[index1] != str2.characters[index2] {
                if i > 0 {
                    return i
                } else {
                    return nil
                }
            }
            index1 = index1.successor()
            index2 = index2.successor()
        }
        return nil
    }
}

extension DiffMatchPatch {
    /*
    
    Converts
    
    ```
    - aaaaaaa
    - bbbbbbb
    + bbbbbbb
    + ccccccc
    ```
    
    into
    
    ```
    - aaaaaaa
      bbbbbbb
    + ccccccc
    ```
    
    */
    public static func cleanupAdjustentDuplicateDiffParts(diffs: [DMPDiff]) -> [DMPDiff] {
        if diffs.count < 2 {
            return diffs
        }
        var index: Int = 0
        var result: [DMPDiff] = Array(diffs[0...1])
        repeat {
            let diff1 = result[index]
            let diff2 = result[index+1]
            switch (diff1.operation, diff2.operation) {
            case (.Insert, .Delete):
                fallthrough
            case (.Delete, .Insert):
                if let length = commonLength(string1: diff1.text, string2: diff2.text) {
                    let newDiffs = adjustDiffs(diff1: diff1, diff2: diff2, commonSubstringLength: length)
                    result.removeRange(Range(start: index, end: index + 2))
                    result += newDiffs
                    result.append(diffs[index+2])
                    index++
                }
            default:
                break
            }
            result.append(diffs[index+2])
            index++
        } while index < diffs.count - 2
        return result
    }
    
    private static func commonLength(string1 str1: String, string2 str2: String) -> Int? {
        let length1 = str1.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        let length2 = str2.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        let total = min(length1, length2)
        if total == 0 {
            return nil
        }
        var commonLength: Int?
        var index1 = str1.endIndex
        var index2 = str2.startIndex
        for i in 1...total {
            index1 = index1.predecessor()
            index2 = index2.successor()
            let substr1 = str1.substringFromIndex(index1)
            let substr2 = str2.substringToIndex(index2)
            if substr1 == substr2 {
                if let length = commonLength where length < i {
                    commonLength = i
                } else if commonLength == nil {
                    commonLength = i
                }
            }
        }
        return commonLength
    }
    
    private static func adjustDiffs(diff1 diff1: DMPDiff, diff2: DMPDiff, commonSubstringLength length: Int) -> [DMPDiff] {
        let text1 = diff1.text
        let text2 = diff2.text
        
        let index1 = advance(text1.endIndex, -length)
        let index2 = advance(text2.startIndex, length)
        
        let newStr = text1.substringFromIndex(index1)
        let equalDiff = DMPDiff(operation: .Equal, andText: newStr)
        
        let str1 = text1.substringToIndex(index1)
        let newDiff1 = DMPDiff(operation: diff1.operation, andText: str1)
        
        let str2 = text2.substringFromIndex(index2)
        let newDiff2 = DMPDiff(operation: diff2.operation, andText: str2)
        
        return [newDiff1, equalDiff, newDiff2]
    }
}


extension DMPOperation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .Insert:
            return "Insert"
        case .Delete:
            return "Delete"
        case .Equal:
            return "Equal"
        }
    }
}

extension DMPDiff {
    override public var description: String {
        return "<\(operation): \(text)>"
    }
}

