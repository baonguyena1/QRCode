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
        // Fix crash when delete row by third partty
        let visibleIndexPaths =  Set(indexPathsForVisibleRows ?? [])
        let updatedRows = Set(changes.updated.map { IndexPath(row: $0, section: 0) }).intersection(visibleIndexPaths)
        
        beginUpdates()
        deleteRows(at: changes.deleted.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        insertRows(at: changes.inserted.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        reloadRows(at: Array(updatedRows), with: .automatic)
        endUpdates()
    }
}
