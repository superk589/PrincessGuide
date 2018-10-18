//
//  StringExtension.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/27.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

extension TimeZone {
    static let tokyo = TimeZone(identifier: "Asia/Tokyo")!
}

extension String {
    
    func toDate(format: String = "yyyy-MM-dd HH:mm:ss", timeZone: TimeZone = .tokyo) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        
        // If not set this, and in your phone settings select a region that defaults to a 24-hour time, for example "United Kingdom" or "France". Then, disable the "24 hour time" from the settings. Now if you create an NSDateFormatter without setting its locale, "HH" will not work.
        // Reference from https://stackoverflow.com/questions/29374181/nsdateformatter-hh-returning-am-pm-on-ios-8-device
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self) ?? Date(timeIntervalSince1970: 0)
    }
    
    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            return self[..<index(startIndex, offsetBy: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeThrough<Int>) -> Substring {
        get {
            return self[...index(startIndex, offsetBy: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeFrom<Int>) -> Substring {
        get {
            return self[index(startIndex, offsetBy: value.lowerBound)...]
        }
    }
    
    subscript(value: CountableRange<Int>) -> Substring {
        get {
            return self[index(startIndex, offsetBy: value.lowerBound)..<index(startIndex, offsetBy: value.upperBound)]
        }
    }
    
    subscript(value: CountableClosedRange<Int>) -> Substring {
        get {
            return self[index(startIndex, offsetBy: value.lowerBound)...index(startIndex, offsetBy: value.upperBound)]
        }
    }
}
