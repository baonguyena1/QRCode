//
//  HistoryDetailViewModel.swift
//  QRCode
//
//  Created by Bao Nguyen on 8/30/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation
import RxSwift

enum StringFormat: Int {
    case url
    case phone
    case email
    case text
}

struct HistoryDetailViewModel {
    var contentVariable = Variable<String>("")
    
    var contentObservable: Observable<StringFormat> {
        return contentVariable.asObservable()
            .map { text -> StringFormat in
                return .text
            }
    }
}
