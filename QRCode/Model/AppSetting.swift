//
//  AppSetting.swift
//  QRCode
//
//  Created by Bao Nguyen on 9/4/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

struct AppSetting {
    static let shared = AppSetting()
    
    func setSound(isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: Constant.isSoundOn)
        UserDefaults.standard.synchronize()
    }
    
    var isSoundOn: Bool {
        get {
            if let sound = UserDefaults.standard.value(forKey: Constant.isSoundOn) {
                return sound as! Bool
            }
            return true
        }
    }
}
