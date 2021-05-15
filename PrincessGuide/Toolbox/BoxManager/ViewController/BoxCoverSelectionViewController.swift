//
//  BoxCoverSelectionViewController.swift
//  PrincessGuide
//
//  Created by zzk on 9/12/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import UIKit

protocol BoxCoverSelectionViewControllerDelegate: AnyObject {
    func boxCoverSelectionViewController(_ boxCoverSelectionViewController: BoxCoverSelectionViewController, didSelect url: URL)
}

class BoxCoverSelectionViewController: CardCollectionViewController {
    
    weak var delegate: BoxCoverSelectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("Choose Chara", comment: "")
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let card = sortedCards[indexPath.item]
        let url = card.iconURL()
        delegate?.boxCoverSelectionViewController(self, didSelect: url)
    }

}
