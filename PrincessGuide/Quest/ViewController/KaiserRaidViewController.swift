//
//  KaiserRaidViewController.swift
//  PrincessGuide
//
//  Created by zzk on 12/23/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import UIKit

class KaiserRaidViewController: QuestEnemyTableViewController {

    init() {
        let waves = DispatchSemaphore.sync { closure in
            Master.shared.getWaves(waveIDs: [801100211, 801100212, 801100213, 801100214, 801100321, 801100322, 801100323], callback: closure)
        } ?? [Wave]()
        super.init(waves: waves)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
