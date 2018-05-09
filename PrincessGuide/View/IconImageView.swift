//
//  IconImageView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Kingfisher

class IconImageView: UIImageView {

    var skillIconID: Int? {
        didSet {
            if let id = skillIconID {
                kf.setImage(with: URL.image.appendingPathComponent("icon/skill/\(id).webp"), placeholder: #imageLiteral(resourceName: "icon_placeholder"))
            }
        }
    }
    
    var itemID: Int? {
        didSet {
            if let id = itemID {
                kf.setImage(with: URL.image.appendingPathComponent("icon/item/\(id).webp"), placeholder: #imageLiteral(resourceName: "icon_placeholder"))
            }
        }
    }
    
    var equipmentID: Int? {
        didSet {
            if let id = equipmentID {
                kf.setImage(with: URL.image.appendingPathComponent("icon/equipment/\(id).webp"), placeholder: #imageLiteral(resourceName: "icon_placeholder"))
            }
        }
    }
    
    var cardID: Int? {
        didSet {
            if let id = cardID {
                kf.setImage(with: URL.image.appendingPathComponent("icon/unit/\(id + 10).webp"), placeholder: #imageLiteral(resourceName: "icon_placeholder_2"))
            }
        }
    }

    var unitID: Int? {
        didSet {
            if let id = unitID {
                kf.setImage(with: URL.image.appendingPathComponent("icon/unit/\(id).webp"), placeholder: #imageLiteral(resourceName: "icon_placeholder_2"))
            }
        }
    }
    
    var shadowUnitID: Int? {
        didSet {
            if let id = shadowUnitID {
                kf.setImage(with: URL.image.appendingPathComponent("icon/unit_shadow/\(id + 10).webp"), placeholder: #imageLiteral(resourceName: "icon_placeholder_2"))
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 64, height: 64)
    }
}
