//
//  PostprocessingPlugins
//  Evdel
//
//  Created by Sash Zats on 7/2/15.
//  Copyright © 2015 Sash Zats. All rights reserved.
//

import Foundation


/**
Plugin that combines two adjacent lines of the opposite operations into no-op, e.g.
```
  xxx
- aaa
+ aaa
  xxx
```
will be converted into
```
  xxx
  aaa
  xxx
```
 */
public struct CombineDeletionInsertionPlugin: DiffPostprocessingPlugin {
    public init() {
        
    }
    
    public func process(diffs: [Diff]) -> [Diff] {
        if diffs.count < 2 {
            return diffs
        }
        var index: Int = 0
        var result: [Diff] = Array(diffs[0...1])
        repeat {
            let diff1 = result[index]
            let diff2 = result[index+1]
            switch (diff1.type, diff2.type) {
            case (.Insertion, .Deletion):
                fallthrough
            case (.Deletion, .Insertion):
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
            if index < diffs.count - 2 {
                result.append(diffs[index+2])
            }
            index++
        } while index < diffs.count - 2
        return result
    }
    
    private func commonLength(string1 str1: String, string2 str2: String) -> Int? {
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

    private func adjustDiffs(diff1 diff1: Diff, diff2: Diff, commonSubstringLength length: Int) -> [Diff] {
        var result: [Diff] = []
        
        let text1 = diff1.text
        let index1 = advance(text1.endIndex, -length)

        let str1 = text1.substringToIndex(index1)
        if !str1.isEmpty {
            result.append(Diff(type: diff1.type, text: str1))
        }
        
        let newStr = text1.substringFromIndex(index1)
        if !newStr.isEmpty {
            result.append(Diff(type: .None, text: newStr))
        }
        
        let text2 = diff2.text
        let index2 = advance(text2.startIndex, length)
        let str2 = text2.substringFromIndex(index2)
        if !str2.isEmpty {
            result.append(Diff(type: diff2.type, text: str2))
        }
        
        return result
    }
}

/**
Bubbling insertion down under assumption that normally most of the code is being added at the bottom:
```
  xxx
+ aaa
  aaa
  xxx
```
transformed into
```
  xxx
  aaa
+ aaa
  xxx
```
 */
public struct BubbleInsertionDown: DiffPostprocessingPlugin {
    public func process(diffs: [Diff]) -> [Diff] {
        fatalError("Not implemented")
    }
}
