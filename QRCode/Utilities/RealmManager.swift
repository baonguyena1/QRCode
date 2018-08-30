//
//  RealmManager.swift
//  QRCode
//
//  Created by Bao Nguyen on 8/30/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import RealmSwift

struct RealmManager {
    
    static let shared: RealmManager = RealmManager()
    static var realm: Realm! {
        return RealmManager.shared.realm
    }
    
    fileprivate var realm: Realm!
    
    init() {
        var config = Realm.Configuration()
        
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("qrCodeRealmData.realm")
        
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
        self.realm = try! Realm()
    }
}
