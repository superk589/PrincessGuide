//
//  CardIconImageView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/24.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Kingfisher

class CardIconImageView: UIImageView {
    
    var cardID: Int? {
        didSet {
            if let id = cardID {
                kf.setImage(with: URL.image.appendingPathComponent("/icon/unit/\(id + 10).webp"))
            }
        }
    }
    
}

