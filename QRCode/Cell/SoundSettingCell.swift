//
//  SoundSettingCell.swift
//  QRCode
//
//  Created by Bao Nguyen on 9/11/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import RxSwift

class SoundSettingCell: UITableViewCell, Identifiable {
    
    @IBOutlet weak var isOpenSoundSwitch: UISwitch!
    fileprivate var bag: DisposeBag = DisposeBag()
    
    static var identifier: String {
        return "soundCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        let iOpenSound = AppSetting.shared.isSoundOn
        isOpenSoundSwitch.isOn = iOpenSound
        setupRx()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate func setupRx() {
        self.isOpenSoundSwitch
            .rx.isOn
            .changed
            .throttle(0.5, scheduler: MainScheduler.instance)
            .asObservable()
            .subscribe(onNext: { (status) in
                AppSetting.shared.setSound(isOn: status)
            })
            .disposed(by: bag)
    }

}
