//
//  History.swift
//  QRCode
//
//  Created by Bao Nguyen on 8/30/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import RealmSwift

class History: Object {
    
    @objc dynamic var content: String = ""
    @objc dynamic var createdDate: Date = Date()
}
