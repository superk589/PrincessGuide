//
//  CustomAcknowViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/5.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt
import AcknowList

class CustomAcknowViewController: AcknowViewController {

    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        super.viewDidLoad()
        textView?.backgroundColor = .clear

        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            themable.textView?.textColor = theme.color.title
            themable.backgroundImageView.image = theme.backgroundImage
        }
    }

}
