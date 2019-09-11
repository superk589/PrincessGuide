//
//  VLTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/8/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Eureka
import SnapKit
import Alamofire
import MJRefresh

class VLTableViewController: UITableViewController {
    
    var models = [VersionLog.DataElement]()
    
    var currentPage = 0
    
    let header = RefreshHeader()
    
    let footer = RefreshFooter()
        
    private lazy var filter = VLFilterViewController.Setting.default.filter

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Version Log", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Options", comment: ""), style: .plain, target: self, action: #selector(handleNavigationRightItem(_:)))
        NotificationCenter.default.addObserver(self, selector: #selector(handleVersionLogSettingsChange(_:)), name: .versionLogFilterDidChange, object: nil)
                
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 44
        
        tableView.tableFooterView = UIView()
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        tableView.register(VLTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: VLTableViewHeaderFooterView.description())
        tableView.register(VLNoScheduleTableViewCell.self, forCellReuseIdentifier: VLNoScheduleTableViewCell.description())
        tableView.register(VLTableViewCell.self, forCellReuseIdentifier: VLTableViewCell.description())
        
        tableView.mj_header = header
        header.refreshingBlock = { [unowned self] in
            self.requestData(page: 1, filter: self.filter)
        }
        
        tableView.mj_footer = footer
        footer.refreshingBlock = { [unowned self] in
            self.requestData(page: self.currentPage + 1, filter: self.filter)
        }
        
        header.beginRefreshing()
    
    }
    
    func requestData(page: Int, filter: VLFilterViewController.Setting.Filter? = nil) {
        
        var parameters: [String: Any] = [
            "page": page
        ]
        
        if filter != VLFilterViewController.Setting.Filter.none {
            parameters["filter"] = filter?.rawValue
        }
        
        Alamofire.request(URL.versionLog, method: .get, parameters: parameters).responseData { [weak self] (response) in
            switch response.result {
            case .failure(let error):
                print(error)
                LoadingHUDManager.default.showErrorMark()
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let versionLog = try decoder.decode(VersionLog.self, from: data)
                    DispatchQueue.main.async {
                        if page >= versionLog.pages {
                            self?.footer.state = .noMoreData
                        } else {
                            self?.footer.state = .idle
                        }
                        
                        self?.currentPage = page
    
                        if page == 1 {
                            self?.models = versionLog.data
                            self?.tableView.reloadData()
                        } else {
                            self?.models += versionLog.data
                            self?.tableView.reloadData()
                        }
                    }
                } catch(let error) {
                    print(error)
                    DispatchQueue.main.async {
                        self?.footer.endRefreshing()
                    }
                }
            }
            DispatchQueue.main.async {
                self?.header.endRefreshing()
            }
        }
    }
    
    @objc private func handleNavigationRightItem(_ item: UIBarButtonItem) {
        let vc = VLFilterViewController()
        vc.modalPresentationStyle = .formSheet
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }
    
    @objc private func handleVersionLogSettingsChange(_ notification: Notification) {
        filter = VLFilterViewController.Setting.default.filter
        currentPage = 0
        requestData(page: 1, filter: filter)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: VLTableViewHeaderFooterView.description()) as! VLTableViewHeaderFooterView
        let model = models[section]
        header.configure(title: model.ver, subTitle: Date(timeIntervalSince1970: TimeInterval(model.time)).toString(format: "(zzz)yyyy-MM-dd HH:mm:ss", timeZone: .current))
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].list[indexPath.row]
        if model.schedule != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: VLTableViewCell.description(), for: indexPath) as! VLTableViewCell
            cell.configure(for: model)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: VLNoScheduleTableViewCell.description(), for: indexPath) as! VLNoScheduleTableViewCell
            cell.configure(for: model)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].list.count
    }
}
