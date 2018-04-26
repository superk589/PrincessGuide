//
//  QuestTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class QuestTableViewController: UITableViewController {

    var quest = [Quest]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
}
