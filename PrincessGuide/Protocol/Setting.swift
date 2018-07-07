//
//  Setting.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

protocol SettingProtocol {
    static var url: URL { get }
    static func load() -> Self?
    func save()
}

extension SettingProtocol where Self: Codable {
    
    static func load() -> Self? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = try? Data(contentsOf: Self.url) else {
            return nil
        }
        return try? decoder.decode(Self.self, from: data)
    }
    
    func save() {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        try? encoder.encode(self).write(to: Self.url)
    }
    
}
