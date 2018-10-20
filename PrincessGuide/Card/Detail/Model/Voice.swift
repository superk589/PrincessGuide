//
//  Voice.swift
//  PrincessGuide
//
//  Created by zzk on 2018/10/20.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class Voice: Codable {
    
    let data: Data
    let url: URL
    
    var identifier: String {
        return url.absoluteString
    }
    
    init(data: Data, url: URL) {
        self.data = data
        self.url = url
    }
    
}
