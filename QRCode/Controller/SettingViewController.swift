//
//  SettingViewController.swift
//  QRCode
//
//  Created by Bao Nguyen on 9/4/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SettingViewController: UIViewController {

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var settingViewModel: SettingViewModel!
    
    fileprivate var soundCell: SoundSettingCell!
    fileprivate var aboutCell: AboutSettingCell!
    fileprivate var versionCell: VersionSettingCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupAds()
    }
    
    fileprivate func setupAds() {
        bannerView.adUnitID = Constant.gadMobileAppID
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)
    }

    fileprivate func setupTableView() {
        self.tableView.tableFooterView = UIView()
        self.soundCell = tableView.dequeueReusableCell(withIdentifier: SoundSettingCell.identifier) as! SoundSettingCell
        self.aboutCell = tableView.dequeueReusableCell(withIdentifier: AboutSettingCell.identifier) as! AboutSettingCell
        self.versionCell = tableView.dequeueReusableCell(withIdentifier: VersionSettingCell.identifier) as! VersionSettingCell
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row == 0 {
            return soundCell
        } else if row == 1 {
            return aboutCell
        }
        return versionCell
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 { // About
            self.performSegue(withIdentifier: SegueIdentifier.gotoAbout, sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
