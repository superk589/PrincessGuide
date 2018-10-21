//
//  Store.swift
//  PrincessGuide
//
//  Created by zzk on 2018/10/20.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation
import Cache
import Alamofire

final class Store {

    static let shared = Store()
    
    private init() { }
    
    let voiceStorage: Storage<Voice>? = {
        let diskConfig = DiskConfig(
            name: "voice",
            expiry: .never,
            directory: try! FileManager.default.url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ),
            protectionType: .none
        )
        
        let memoryConfig = MemoryConfig()
        
        let storage = try? Storage(
            diskConfig: diskConfig,
            memoryConfig: memoryConfig,
            transformer: TransformerFactory.forCodable(ofType: Voice.self)
        )
        return storage
    }()
    
    var voiceRequest: DataRequest?
}

extension Store {
    
    func voice(from url: URL, completion: @escaping (Voice?) -> Void) {
        voiceRequest?.cancel()
        if let voice = try? voiceStorage?.object(forKey: url.absoluteString) {
            completion(voice)
        } else {
            voiceRequest = requestVoiceData(from: url) { (data) in
                if let data = data {
                    let voice = Voice(data: data, url: url)
                    try? self.voiceStorage?.setObject(voice, forKey: url.absoluteString)
                    completion(voice)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    private func requestVoiceData(from url: URL, completion: @escaping (Data?) -> Void) -> DataRequest {
        return Alamofire.request(url).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}
