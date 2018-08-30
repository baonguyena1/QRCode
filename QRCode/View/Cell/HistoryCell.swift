//
//  HistoryCell.swift
//  QRCode
//
//  Created by Bao Nguyen on 8/30/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import SwipeCellKit

class HistoryCell: SwipeTableViewCell, Identifiable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
//    var indicatorView = IndicatorView(frame: .zero)
    
    static var identifier: String {
        return "historyCell"
    }
    
    var history: History! {
        didSet {
            self.titleLabel.text = history.content
            self.subtitleLabel.text = history.createdDate.toString
        }
    }
    
    fileprivate func setupIndicatorView() {
//        indicatorView.translatesAutoresizingMaskIntoConstraints = false
//        indicatorView.color = tintColor
//        indicatorView.backgroundColor = .clear
//        contentView.addSubview(indicatorView)
//
//        let size: CGFloat = 12
//        indicatorView.widthAnchor.constraint(equalToConstant: size).isActive = true
//        indicatorView.heightAnchor.constraint(equalTo: indicatorView.widthAnchor).isActive = true
//        indicatorView.centerXAnchor.constraint(equalTo: fromLabel.leftAnchor, constant: -16).isActive = true
//        indicatorView.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor).isActive = true
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupIndicatorView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
