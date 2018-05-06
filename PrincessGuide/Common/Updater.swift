//
//  Updater.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/27.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

extension URL {
    static let check = URL(string: "https://redive.estertion.win/last_version.json")!
    static func master(hash: String) -> URL {
        return URL(string: "https://priconne-redive.akamaized.net/dl/pool/AssetBundles/\(hash[0..<2])/\(hash)")!
    }
}

extension Notification.Name {
    
    static let updateEnd = Notification.Name("update_end")
    
}

class Updater {
    
    static let shared = Updater()
    
    var isUpdating = false {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                UIApplication.shared.isNetworkActivityIndicatorVisible = self.isUpdating
            }
        }
    }
    
    private func postUpdateEndNotification() {
        NotificationCenter.default.post(name: .updateEnd, object: self)
    }
    
    private init() {

    }
    
    func checkTruthVersion(completion: @escaping (_ version: String?, _ hash: String?, _ error: Error?) -> Void) {
        isUpdating = true
        Alamofire.request(URL.check).validate(statusCode: 200..<300).responseData { [unowned self] (response) in
            switch response.result {
            case .failure(let error):
                print(error)
                completion(nil, nil, error)
            case .success(let data):
                let json = JSON(data)
                if let truthVersion = json["TruthVersion"].string, let hash = json["hash"].string {
                    completion(truthVersion, hash, nil)
                }
            }
            self.isUpdating = false
        }
    }
    
    func getMaster(hash: String, progressHandler: @escaping Request.ProgressHandler, completion: @escaping (_ master: Data?, _ error: Error?) -> Void) {
        isUpdating = true
        Alamofire.request(URL.master(hash: hash)).downloadProgress(closure: progressHandler).validate(statusCode: 200..<300).responseData { [unowned self] (response) in
            switch response.result {
            case .failure(let error):
                print(error)
                completion(nil, error)
            case .success(let data):
                do {
                    let result = try extractBundle(data: data)
                    guard let asset = result.first else {
                        throw UnityFSError.invalidData
                    }
                    let db = try extractAsset(data: asset.data)
                    try db.write(to: Master.url, options: .atomic)
                    ConsoleVariables.defualt.handleDataUpdatingEnd()
                    completion(db, nil)
                } catch(let error) {
                    print(error)
                    completion(nil, error)
                }
            }
            self.isUpdating = false
        }
    }
    
}
