//
//  SkillIconImageView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/24.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Kingfisher

class SkillIconImageView: UIImageView {
    
    var iconID: Int? {
        didSet {
            if let id = iconID {
                kf.setImage(with: URL.image.appendingPathComponent("/icon/skill/\(id).webp"))
            }
        }
    }
    
}
