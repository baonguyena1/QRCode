//
//  UITableView+Helper.swift
//  QRCode
//
//  Created by Bao Nguyen on 8/30/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import RxRealm

extension UITableView {
    func applyChangeset(_ changes: RealmChangeset) {
        beginUpdates()
        deleteRows(at: changes.deleted.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        insertRows(at: changes.inserted.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        reloadRows(at: changes.updated.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        endUpdates()
    }
}
