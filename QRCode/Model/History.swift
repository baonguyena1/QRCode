//
//  History.swift
//  QRCode
//
//  Created by Bao Nguyen on 8/30/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import RealmSwift

enum ContentType: Int {
    case url
    case email
    case phone
    case text
    
    var image: UIImage {
        switch self {
        case .url:
            return #imageLiteral(resourceName: "ic_web")
        case .email:
            return #imageLiteral(resourceName: "ic_mail")
        case .phone:
            return #imageLiteral(resourceName: "ic_phone")
        case .text:
            return #imageLiteral(resourceName: "ic_text")
        }
    }
}

class History: Object {
    
    @objc dynamic var content: String = ""
    @objc dynamic var createdDate: Date = Date()
    
    var contentType: ContentType {
        if content.isURL() {
            return .url
        } else if content.isEmail() {
            return .email
        } else if content.isPhone() {
            return .phone
        }
        return .text
    }
}
