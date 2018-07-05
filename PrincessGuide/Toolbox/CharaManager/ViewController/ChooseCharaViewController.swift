//
//  ChooseCharaViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/6/29.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class ChooseCharaViewController: SearchableCardTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Select Chara", comment: "")
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = cardOf(indexPath: indexPath)
        let vc = EditCharaViewController(card: card)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
