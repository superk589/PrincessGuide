//
//  BatchEditCharaInBoxViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

protocol BatchEditCharaInBoxViewControllerDelegate: class {
    func batchEditCharaInBoxViewController(_ batchEditCharaInBoxViewController: BatchEditCharaInBoxViewController, didSave charas: [Chara])
}

class BatchEditCharaInBoxViewController: BatchEditViewController {

    weak var delegate: BatchEditCharaInBoxViewControllerDelegate?
    
    override func didSave() {
        navigationController?.popViewController(animated: true)
        delegate?.batchEditCharaInBoxViewController(self, didSave: charas)
    }

}
