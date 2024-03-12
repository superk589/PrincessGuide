//
//  QuestEnemyTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/9.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class QuestEnemyTableViewController: UITableViewController {
    
    struct Row {
        var type: UITableViewCell.Type
        var data: Model
        
        enum Model {
            case quest(String)
            case wave(Wave, Int)
            case clanBattleWave(Wave, Int, Double)
            case tower([Enemy], Int)
            case hatsuneEvent(Wave, String)
            case cloister(TowerCloister.Wave, Int)
            case waveAndTitle(Wave, String?)
            case talentWave(TalentQuest.Wave, String?)
        }
    }

    var rows: [Row]
    
    init(quests: [Quest]) {
        self.rows = quests.flatMap {
            [Row(type: QuestNameTableViewCell.self, data: .quest($0.base.questName))] +
                $0.waves.enumerated().map{ Row(type: QuestEnemyTableViewCell.self, data: .wave($0.element, $0.offset)) }
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    init(clanBattle: ClanBattle, mode: ClanBattleTableViewController.Mode) {
        let rounds: [ClanBattle.Round]
        if mode == .easy {
            rounds = clanBattle.mergedSimpleRounds
        } else {
            rounds = clanBattle.mergedRounds
        }
        self.rows = rounds.flatMap {
            [Row(type: QuestNameTableViewCell.self, data: .quest($0.name))] +
                $0.groups.enumerated().compactMap {
                    if let wave = $0.element.wave {
                        return Row(type: ClanBattleEnemyTableViewCell.self, data: .clanBattleWave(wave, $0.offset, $0.element.scoreCoefficient))
                    } else {
                        return nil
                    }
                }
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    init(towerQuests: [Tower.Quest]) {
        self.rows = towerQuests.map {
            Row(type: QuestEnemyTableViewCell.self, data: .tower($0.enemies, $0.floorNum))
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    init(towerCloister: TowerCloister) {
        self.rows = towerCloister.waves.enumerated().map {
            Row(type: QuestEnemyTableViewCell.self, data: .cloister($0.element, $0.offset))
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    init(hatsuneEvent: HatsuneEvent) {
        self.rows = hatsuneEvent.quests.compactMap { quest in
            quest.wave.map {
                Row(type: QuestEnemyTableViewCell.self, data: .hatsuneEvent($0, quest.difficultyType.description))
            }
        } + hatsuneEvent.specialBattles.compactMap { specialBattle in
            specialBattle.wave.map {
                Row(type: QuestEnemyTableViewCell.self, data: .hatsuneEvent($0, String(format: "SP Mode %d", specialBattle.mode)))
            }
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    init(shioriEvent: ShioriEvent) {
        self.rows = shioriEvent.quests.compactMap { quest in
            quest.wave.map {
                Row(type: QuestEnemyTableViewCell.self, data: .hatsuneEvent($0, quest.difficultyType.description))
            }
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    init(rarity6UnlockQuest: Rarity6UnlockQuest) {
        self.rows = rarity6UnlockQuest.wave.flatMap {
            [Row(type: QuestEnemyTableViewCell.self, data: .wave($0, 0))]
        } ?? []
        super.init(nibName: nil, bundle: nil)
    }
    
    init(waves: [Wave]) {
        self.rows = waves.map {
            Row(type: QuestEnemyTableViewCell.self, data: .waveAndTitle($0, $0.enemies.first?.enemy?.base.name))
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    init(floors: [SecretFloor]) {
        self.rows = floors.compactMap { floor in
            floor.wave.flatMap { wave in
                Row(type: QuestEnemyTableViewCell.self, data: .waveAndTitle(wave, String(floor.floorNum)))
            }
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    init(trialBattles: [TrialBattle]) {
        self.rows = trialBattles.compactMap { battle in
            battle.wave.flatMap { wave in
                Row(type: QuestEnemyTableViewCell.self, data: .waveAndTitle(wave, battle.battleName))
            }
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    init(talentQuests: [TalentQuest]) {
        self.rows = talentQuests.compactMap { quest in
            if let wave = quest.wave {
                return Row(type: QuestEnemyTableViewCell.self, data: .talentWave(wave, quest.questName))
            } else {
                return nil
            }
        }
        super.init(nibName: nil, bundle: nil)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 88
        tableView.rowHeight = UITableView.automaticDimension
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.register(QuestEnemyTableViewCell.self, forCellReuseIdentifier: QuestEnemyTableViewCell.description())
        tableView.register(QuestNameTableViewCell.self, forCellReuseIdentifier: QuestNameTableViewCell.description())
        tableView.register(ClanBattleEnemyTableViewCell.self, forCellReuseIdentifier: ClanBattleEnemyTableViewCell.description())
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [weak self] (context) in
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
        }, completion: nil)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.type.description(), for: indexPath)
        
        switch (cell, row.data) {
        case (let cell as QuestEnemyTableViewCell, .wave(let wave, let index)):
            cell.delegate = self
            let format = NSLocalizedString("Wave %d", comment: "")
            let title = String(format: format, index + 1)
            let enemies = wave.enemies.flatMap { [$0.enemy] + ($0.enemy?.parts ?? [])}.compactMap { $0 }
            cell.configure(for: enemies, title: title)
        case (let cell as ClanBattleEnemyTableViewCell, .clanBattleWave(let wave, let index, let coefficient)):
            cell.delegate = self
            let format = NSLocalizedString("Wave %d (x%.2f)", comment: "")
            let title = String(format: format, index + 1, coefficient)
            let enemies = wave.enemies.flatMap { [$0.enemy] + ($0.enemy?.parts ?? [])}.compactMap { $0 }
            cell.configure(for: enemies, title: title)
        case (let cell as QuestNameTableViewCell, .quest(let name)):
            cell.configure(for: name)
        case (let cell as QuestEnemyTableViewCell, .tower(let enemies, let floor)):
            cell.configure(for: enemies, title: String(floor))
            cell.delegate = self
        case (let cell as QuestEnemyTableViewCell, .hatsuneEvent(let wave, let title)):
            let enemies = wave.enemies.flatMap { [$0.enemy] + ($0.enemy?.parts ?? [])}.compactMap { $0 }
            cell.configure(for: enemies, title: title)
            cell.delegate = self
        case (let cell as QuestEnemyTableViewCell, .cloister(let wave, let index)):
            let enemies = wave.enemies.flatMap { [$0] + $0.parts }.compactMap { $0 }
            let format = NSLocalizedString("Wave %d", comment: "")
            let title = String(format: format, index + 1)
            cell.configure(for: enemies, title: title)
            cell.delegate = self
        case (let cell as QuestEnemyTableViewCell, .waveAndTitle(let wave, let title)):
            cell.configure(for: wave.enemies.flatMap { [$0.enemy] + ($0.enemy?.parts ?? [])}.compactMap { $0 }, title: title ?? "")
            cell.delegate = self
        case (let cell as QuestEnemyTableViewCell, .talentWave(let wave, let title)):
            cell.configure(for: wave.enemies.flatMap { [$0] + ($0.parts)}.compactMap { $0 }, title: title ?? "")
            cell.delegate = self
        default:
            break
        }
        return cell
    }
    
}

extension QuestEnemyTableViewController: QuestEnemyTableViewCellDelegate {
    
    func questEnemyTableViewCell(_ questEnemyTableViewCell: QuestEnemyTableViewCell, didSelect enemy: Enemy) {
        let vc = EDTabViewController(enemy: enemy)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension QuestEnemyTableViewController: ClanBattleEnemyTableViewCellDelegate {
    func clantBattleEmetyTableViewCell(_ clanBattleEnemyTableViewCell: ClanBattleEnemyTableViewCell, didSelect enemy: Enemy) {
        let vc = EDTabViewController(enemy: enemy)
        navigationController?.pushViewController(vc, animated: true)
    }
}
