//
//  DateExtension.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

extension Date {
    
    func toString(format: String = "yyyy-MM-dd HH:mm:ss", timeZone: TimeZone = .tokyo) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = format
        
        // If not set this, and in your phone settings select a region that defaults to a 24-hour time, for example "United Kingdom" or "France". Then, disable the "24 hour time" from the settings. Now if you create an NSDateFormatter without setting its locale, "HH" will not work.
        // Reference from https://stackoverflow.com/questions/29374181/nsdateformatter-hh-returning-am-pm-on-ios-8-device
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }
    
    func truncateHours(timeZone: TimeZone = .tokyo) -> Date {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = timeZone
        let comps = gregorian.dateComponents([.day, .month, .year], from: self)
        return gregorian.date(from: comps)!
    }
}
