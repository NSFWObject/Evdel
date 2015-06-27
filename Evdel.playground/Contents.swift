//: Playground - noun: a place where people can play

import AppKit

let str1 = "\\n@end\n\n@interface WMLAuthenticationResponse : WMLAPIResponse\n\n"
let str2 = "\\n@end\n\n"

let x = str1.commonPrefixWithString(str2, options: NSStringCompareOptions(rawValue: 0))