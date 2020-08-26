//
//  CDTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/6.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import AVFoundation
import Reusable

class CDTableViewController: UITableViewController, CDImageTableViewCellDelegate {
    
    enum Row {
        case card(Card)
        case skill(skill: Skill, category: SkillCategory, property: Property, index: Int?)
        case minion(Minion)
        case pattern(pattern: AttackPattern, card: Card, index: Int?)
        case promotion(Card.Promotion)
        case profileItems([Card.Profile.Item])
        case propertyItems(items: [Property.Item], unitLevel: Int, targetLevel: Int, enablesComparisonMode: Bool)
        case comment(Card.Comment)
        case textArray([TextItem])
        case album(title: String, urls: [URL], thumbnailURLs: [URL])
        case commentText(String)
        case uniqueEquipments([Int])
    }
    
    var card: Card? {
        didSet {
            reloadAll()
        }
    }
    
    func reloadAll() {
        navigationItem.title = card?.base.unitName
        if let card = card {
            prepareRows(for: card)
            tableView.reloadData()
        }
    }
    
    private var voicePlayer = VoicePlayer()
    
    var rows = [Row]()
    
    /// should be overrided by subclasses
    func prepareRows(for card: Card) {

    }
        
    private var observations = [NSKeyValueObservation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.register(cellType: CDBasicTableViewCell.self)
        tableView.register(cellType: CDPromotionTableViewCell.self)
        tableView.register(cellType: CDSkillTableViewCell.self)
        tableView.register(cellType: CDPatternTableViewCell.self)
        tableView.register(cellType: CDProfileTableViewCell.self)
        tableView.register(cellType: CDMinionTableViewCell.self)
        tableView.register(cellType: CDCommentTableViewCell.self)
        tableView.register(cellType: CDImageTableViewCell.self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [weak self] (context) in
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
            }, completion: nil)
        super.viewWillTransition(to: size, with: coordinator)
    }
        
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        switch row {
        case .album(let title, _, let thumbnailURLS):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CDImageTableViewCell.self)
            cell.configure(for: thumbnailURLS, title: title)
            cell.delegate = self
            return cell
        case .card(let card):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CDBasicTableViewCell.self)
            cell.configure(
                comment: card.base.comment.replacingOccurrences(of: "\\n", with: "\n"),
                iconURL: card.iconURL()
            )
            return cell
        case .comment(let comment):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CDCommentTableViewCell.self)
            cell.configure(for: comment.description.replacingOccurrences(of: "\\n", with: "\n"))
            cell.delegate = self
            return cell
        case .commentText(let text):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CDCommentTableViewCell.self)
            cell.configure(for: text)
            cell.delegate = self
            return cell
        case .minion(let minion):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CDMinionTableViewCell.self)
            let format = NSLocalizedString("Minion: %d", comment: "")
            cell.configure(title: String(format: format, minion.base.unitId))
            return cell
        case .pattern(let pattern, let card, let index):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CDPatternTableViewCell.self)
            cell.configure(
                title: index.flatMap { "\(NSLocalizedString("Attack Pattern", comment: "")) \($0)" } ?? NSLocalizedString("Attack Pattern", comment: ""),
                items: pattern.toCollectionViewItems(card: card)
            )
            return cell
        case .profileItems(let items):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CDProfileTableViewCell.self)
            cell.configure(items: items.map {
                TextItem(title: $0.key.description, content: $0.value, colorMode: .normal)
            })
            return cell
        case .promotion(let promotion):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CDPromotionTableViewCell.self)
            var extraStrings = [String]()
            if card?.maxEnergyRecoveryRateRank == promotion.promotionLevel {
                let format = NSLocalizedString("Max. %@: %@", comment: "")
                extraStrings.append(String(format: format, PropertyKey.energyRecoveryRate.description, card?.property(unitRank: promotion.promotionLevel).energyRecoveryRate.roundedString(roundingRule: nil) ?? ""))
            }
            if card?.maxEnergyReduceRank == promotion.promotionLevel {
                let format = NSLocalizedString("Max. %@: %@", comment: "")
                extraStrings.append(String(format: format, PropertyKey.energyReduceRate.description, card?.property(unitRank: promotion.promotionLevel).energyReduceRate.roundedString(roundingRule: nil) ?? ""))
            }
            let baseString = NSLocalizedString("Rank", comment: "") + " \(promotion.promotionLevel)"
            cell.configure(
                title: ([baseString] + extraStrings).joined(separator: "\n"),
                imageURLs: promotion.equipSlots.map { URL.resource.appendingPathComponent("icon/equipment/\($0).webp") }
            )
            cell.delegate = self
            return cell
        case .propertyItems(let items, let unitLevel, let targetLevel, let enablesComparisonMode):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CDProfileTableViewCell.self)
            cell.configure(items: items.map {
                let content: String
                if let percent = $0.percent(selfLevel: unitLevel, targetLevel: targetLevel), percent != 0, !enablesComparisonMode {
                    if $0.hasLevelAssumption {
                        content = String(format: "%d(%.2f%%, %d to %d)", Int($0.value), percent, unitLevel, targetLevel)
                    } else {
                        content = String(format: "%d(%.2f%%)", Int($0.value), percent)
                    }
                } else {
                    content = String(Int($0.value))
                }
                return TextItem(
                    title: $0.key.description,
                    content: content,
                    deltaValue: enablesComparisonMode ? $0.value : 0
                )
            })
            return cell
        case .skill(let skill, let category, let property, let index):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CDSkillTableViewCell.self)
            cell.configure(for: skill, category: category, property: property, index: index)
            return cell
        case .textArray(let items):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CDProfileTableViewCell.self)
            cell.configure(items: items)
            return cell
        case .uniqueEquipments(let ids):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CDPromotionTableViewCell.self)
            cell.configure(
                title: NSLocalizedString("Unique Equipments", comment: ""),
                imageURLs: ids.map { URL.resource.appendingPathComponent("icon/equipment/\($0).webp") })
            cell.delegate = self
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = rows[indexPath.row]
        switch row {
        case .minion(let minion):
            let vc = MinionTabViewController(minion: minion)
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func cdImageTableViewCell(_ cdImageTableViewCell: CDImageTableViewCell, didSelect imageView: UIImageView, url: URL?) {
        
    }
}

extension CDTableViewController: CDPromotionTableViewCellDelegate {
    
    func cdPromotionTableViewCell(_ cdPromotionTableViewCell: CDPromotionTableViewCell, didSelect index: Int) {
        guard let indexPath = tableView.indexPath(for: cdPromotionTableViewCell) else {
            return
        }
        
        let row = rows[indexPath.row]
        switch row {
        case .uniqueEquipments(let ids):
            let id = ids[index]
            let equipments = DispatchSemaphore.sync { (closure) in
                Master.shared.getUniqueEquipments(equipmentIDs: [id]) { equipments in
                    closure(equipments)
                }
            }
            guard let equipment = equipments?.first else {
                return
            }
            
            let vc = UniqueCraftTableViewController()
            vc.navigationItem.title = equipment.equipmentName
            vc.equipment = equipment
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .promotion(let promotion):
            let id = promotion.equipSlots[index]
            let equipments = DispatchSemaphore.sync { (closure) in
                Master.shared.getEquipments(equipmentID: id) { equipments in
                    closure(equipments)
                }
            }
            guard let equipment = equipments?.first else {
                return
            }
            if equipment.craftFlg == 0 {
                DropSummaryTableViewController.configureAsync(equipment: equipment) { [weak self] (vc) in
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                let vc = CraftTableViewController()
                vc.navigationItem.title = equipment.equipmentName
                vc.equipment = equipment
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }
}

extension CDTableViewController: CDCommentTableViewCellDelegate {
    func doubleClick(on cdCommentTableViewCell: CDCommentTableViewCell) {
        
        guard let indexPath = tableView.indexPath(for: cdCommentTableViewCell) else {
            return
        }
        
        guard case .comment(let comment) = rows[indexPath.row] else {
            return
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? CDCommentTableViewCell else {
            return
        }
        
        cell.loadingIndicator.startAnimating()
        Store.shared.voice(from: comment.soundURL) { [weak self] (voice) in
            cell.loadingIndicator.stopAnimating()
            if let voice = voice {
                self?.voicePlayer.play(voice)
            }
        }
        
    }
    
}
