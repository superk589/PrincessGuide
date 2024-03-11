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
import BrotliKit

extension URL {
    static let versionLog = URL(string: "https://redive.estertion.win/ver_log_redive/")!
    static let check = URL(string: "https://wthee.xyz/pcr/api/v1/db/info/v2")!
    static func master(_ hash: String) -> URL {
        return URL(string: "https://wthee.xyz/db/redive_jp.db.br")!
    }
    static let notice = URL(string: "https://estertion.github.io/hatsunes_notes_notice/hn_notice.json")!
}

extension Notification.Name {
    static let updateEnd = Notification.Name("update_end")
}

class Updater {
    
    static let shared = Updater()
    
    var isUpdating = false
    
    private init() {

    }
    
    func checkTruthVersion(completion: @escaping (_ version: String?, _ hash: String?, _ error: Error?) -> Void) {
        isUpdating = true
        AF.request(URL.check, method: .post, parameters: ["regionCode": "jp"], encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300).responseData { [unowned self] (response) in
            switch response.result {
            case .failure(let error):
                print(error)
                completion(nil, nil, error)
            case .success(let data):
                let json = JSON(data)
                if let truthVersion = json["data"]["truthVersion"].string, let hash = json["data"]["hash"].string {
                    completion(truthVersion, hash, nil)
                }
            }
            self.isUpdating = false
        }
    }
    
    func getMaster(hash: String, progressHandler: @escaping Request.ProgressHandler, completion: @escaping (_ master: Data?, _ error: Error?) -> Void) {
        isUpdating = true
        AF.request(URL.master(hash)).downloadProgress(closure: progressHandler).validate(statusCode: 200..<300).responseData { [unowned self] (response) in
            switch response.result {
            case .failure(let error):
                print(error)
                completion(nil, error)
            case .success(let data):
                do {
                    guard let db = BrotliCompressor.decompressedData(with: data) else {
                        completion(nil, NSError())
                        return
                    }
                    try db.write(to: Master.url, options: .atomic)
                    NotificationCenter.default.post(name: .updateEnd, object: nil)
                    completion(db, nil)
                } catch(let error) {
                    print(error)
                    completion(nil, error)
                }
            }
            self.isUpdating = false
        }
    }
    
    func getNotice(completion: @escaping (_ noticePayload: NoticePayload?) -> Void) {
        URLCache.shared.removeAllCachedResponses()
        AF.request(URL.notice).validate(statusCode: 200..<300).responseData { (response) in
            switch response.result {
            case .failure(let error):
                print(error)
                completion(nil)
            case .success(let data):
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    let payload = try jsonDecoder.decode(NoticePayload.self, from: data)
                    completion(payload)
                } catch(let error) {
                    print(error)
                    completion(nil)
                }
            }
        }
    }
    
}
