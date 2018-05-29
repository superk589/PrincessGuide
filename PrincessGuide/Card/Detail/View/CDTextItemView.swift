//
//  CDTextItemView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/29.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

typealias CDTextItemView = ProfileItemView

extension CDTextItemView {
    
    func configure(for title: String, content: String) {
        titleLabel.text = title
        contentLabel.text = content.replacingOccurrences(of: "\\n", with: "\n")
    }
    
}
