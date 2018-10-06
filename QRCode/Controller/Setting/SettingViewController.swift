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
        
    }
}

extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Sound"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        var cell: UITableViewCell = UITableViewCell()
        if section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: SoundSettingCell.identifier, for: indexPath)
        } else if section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: AboutSettingCell.identifier, for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: VersionSettingCell.identifier, for: indexPath)
        }
        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 { // About
            self.performSegue(withIdentifier: SegueIdentifier.gotoAbout, sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
