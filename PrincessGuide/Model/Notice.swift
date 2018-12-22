//
//  Notice.swift
//  PrincessGuide
//
//  Created by zzk on 2018/12/22.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

struct NoticePayload: Codable {
    
    /// version number in string eg. "1.0.0"
    var version: String
    
    var `default`: String
    
    /// { "ja" : "notice content in Japanese" , "zh-Hans" : "notice content in simplified Chinese" }
    var contents: [String: String]
    
}

extension NoticePayload {
    
    var localizedContent: String? {
        if let identifier = Locale.preferredLanguages.first {
            return contents.filter { identifier.hasPrefix($0.key) }.max { $0.key.count < $1.key.count }?.value ?? contents[`default`]
        }
        return contents[`default`]
    }
}
