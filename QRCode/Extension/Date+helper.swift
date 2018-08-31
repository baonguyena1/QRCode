//
//  Date+helper.swift
//  QRCode
//
//  Created by Bao Nguyen on 8/30/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

extension Date {
    var toString: String {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formater.string(from: self)
    }
}
