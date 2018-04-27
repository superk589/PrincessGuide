//
//  DeviceInfo.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/27.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation
import CoreTelephony
import Reachability

class DeviceInfo: CustomStringConvertible {
    
    static let `default` = DeviceInfo()
    
    let appName = Config.appName
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
    var device: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    let osVersion = UIDevice.current.systemVersion
    
    let language = Locale.preferredLanguages.first ?? ""
    
    var carrier: String {
        let info = CTTelephonyNetworkInfo.init()
        return info.subscriberCellularProvider?.carrierName ?? ""
    }
    
    var timeZone: String {
        return TimeZone.current.abbreviation() ?? ""
    }
    
    var connection: String {
        if let reachability = Reachability(hostname: "https://www.baidu.com") {
            return reachability.connection.description
        } else {
            return NSLocalizedString("Unknown", comment: "")
        }
    }
    
    var description: String {
        return "App Information:\nApp Name: \(appName)\nApp Version: \(appVersion)\n\nDevice Information:\nDevice: \(device)\niOS Version: \(osVersion)\nLanguage: \(language)\nCarrier: \(carrier)\nTimezone: \(timeZone)\nConnection Status: \(connection)"
    }
    
}
