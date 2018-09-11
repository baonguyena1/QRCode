//
//  VersionSettingCell.swift
//  QRCode
//
//  Created by Bao Nguyen on 9/11/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class VersionSettingCell: UITableViewCell, Identifiable {
    
    @IBOutlet weak var versionLabel: UILabel!
    
    static var identifier: String {
        return "versionCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
        versionLabel.text = build
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
