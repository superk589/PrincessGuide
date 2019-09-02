//
//  TextItem.swift
//  PrincessGuide
//
//  Created by zzk on 9/2/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import UIKit

struct TextItem {
    
    enum ColorMode {
        case down
        case up
        case normal
    }
    
    let title: String
    let content: String
    let colorMode: ColorMode
}

extension TextItem {
    init(title: String, content: String, deltaValue: Double) {
        let colorMode: ColorMode
        if deltaValue > 0 {
            colorMode = .up
        } else if deltaValue == 0 {
            colorMode = .normal
        } else {
            colorMode = .down
        }
        self.init(title: title, content: content, colorMode: colorMode)
    }
    init(title: String, content: String, deltaValue: Int) {
        self.init(title: title, content: content, deltaValue: Double(deltaValue))
    }
}
