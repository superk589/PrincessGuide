//
//  EditCharaInBoxViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/6.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

protocol EditCharaInBoxViewControllerDelegate: AnyObject {
    func editCharaInBoxViewController(_ editCharaInBoxViewController: EditCharaInBoxViewController, didSave chara: Chara)
}

class EditCharaInBoxViewController: EditCharaViewController {
    
    weak var delegate: EditCharaInBoxViewControllerDelegate?

    override func didSave() {
        navigationController?.popViewController(animated: true)
        if let chara = chara {
            delegate?.editCharaInBoxViewController(self, didSave: chara)
        }
    }
}
