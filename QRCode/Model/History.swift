//
//  History.swift
//  QRCode
//
//  Created by Bao Nguyen on 8/30/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import RealmSwift

//enum ContentType: Int {
//    case url
//    case email
//    case phone
//    case text
//
//    var image: UIImage {
//        switch self {
//        case .url:
//            return #imageLiteral(resourceName: "ic_web")
//        case .email:
//            return #imageLiteral(resourceName: "ic_mail")
//        case .phone:
//            return #imageLiteral(resourceName: "ic_phone")
//        case .text:
//            return #imageLiteral(resourceName: "ic_barcode_scanner")
//        }
//    }
//}

class History: Object {
    
    @objc dynamic var content: String = ""
    @objc dynamic var createdDate: Date = Date()
    
    static func object(with content: String) -> History? {
        return RealmManager.realm.objects(History.self).filter("content == \(content)").first
    }
}
