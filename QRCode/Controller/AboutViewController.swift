//
//  AboutViewController.swift
//  QRCode
//
//  Created by Bao Nguyen on 9/4/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AboutViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAds()
    }

    fileprivate func setupAds() {
        bannerView.adUnitID = Constant.gadMobileAppID
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)
    }
}
