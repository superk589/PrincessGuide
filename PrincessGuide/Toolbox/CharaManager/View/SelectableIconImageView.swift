//
//  SelectableIconImageView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/3.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Kingfisher

class SelectableIconImageView: IconImageView {

    var isSelected: Bool = false {
        didSet {
            if isSelected {
                super.image = originalImage
            } else {
                super.image = blackWhiteImage
            }
        }
    }
    
    private var originalImage: UIImage?
    
    private var blackWhiteImage: UIImage?
    
    override var image: UIImage? {
        set {
            originalImage = newValue
            if let image = newValue {
                let processor = BlackWhiteProcessor()
                blackWhiteImage = processor.process(item: .image(image), options: [])
            } else {
                blackWhiteImage = nil
            }
            if isSelected {
                super.image = originalImage
            } else {
                super.image = blackWhiteImage
            }
        }
        get {
            return super.image
        }
    }

}
