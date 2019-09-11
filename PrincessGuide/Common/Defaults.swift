//
//  Defaults.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/27.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

struct Defaults {

    @UserDefault("download_at_start", defaultValue: true)
    static var downloadAtStart: Bool

}
