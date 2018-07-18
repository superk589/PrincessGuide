//
//  CDTextItemView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/29.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

typealias CDTextItemView = ProfileItemView

extension CDTextItemView {
    
    func configure(for title: String, content: String, comparisonMode: Bool) {
        titleLabel.text = title
        contentLabel.text = content.replacingOccurrences(of: "\\n", with: "\n")
        
        if let value = Double(content), comparisonMode {
            if value > 0 {
                ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
                    themeable.contentLabel.textColor = theme.color.upValue
                }
            } else if value < 0 {
                ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
                    themeable.contentLabel.textColor = theme.color.downValue
                }
            } else {
                ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
                    themeable.contentLabel.textColor = theme.color.body
                }
            }
        }
    }
    
}
