//
//  SettingController.swift
//  QRCode
//
//  Created by Bao Nguyen on 9/4/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import RxSwift

class SettingController: UITableViewController {

    @IBOutlet weak var playSoundSwitch: UISwitch!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let isSoundOn = AppSetting.shared.isSoundOn
        playSoundSwitch.isOn = isSoundOn
        setupRx()
    }
    
    fileprivate func setupRx() {
        self.playSoundSwitch
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
