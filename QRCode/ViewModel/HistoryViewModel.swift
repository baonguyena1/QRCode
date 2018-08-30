//
//  HistoryViewModel.swift
//  QRCode
//
//  Created by Bao Nguyen on 8/30/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import RealmSwift
import RxRealm
import RxSwift

struct HistoryViewModel {
    
    lazy var histories = RealmManager.realm
        .objects(History.self)
        .sorted(byKeyPath: "createdDate", ascending: true)
    
    mutating func getHistories() -> Observable<(AnyRealmCollection<History>, RealmChangeset?)> {
        return Observable.changeset(from: self.histories)
    }
}
