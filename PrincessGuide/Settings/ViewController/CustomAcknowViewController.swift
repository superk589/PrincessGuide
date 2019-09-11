//
//  CustomAcknowViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/5.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import AcknowList

class CustomAcknowViewController: AcknowViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView?.backgroundColor = .clear
        textView?.textColor = Theme.dynamic.color.title
        view.backgroundColor = Theme.dynamic.color.background
    }

}
