//
//  GADManager.swift
//  QRCode
//
//  Created by Bao Nguyen on 8/31/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation
import GoogleMobileAds

class GADManager: NSObject {

    static let shared = GADManager()
    fileprivate var interstitial: GADInterstitial!
    fileprivate var timer: Timer?
    
    override init() {
        super.init()
        Logger.log("")
        self.interstitial = self.createAndLoadInterstitial()
        self.startTimer()
        // Pause game when application enters background.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidEnterBackground),
                                               name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
        // Resume game when application becomes active.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    @objc fileprivate func applicationDidEnterBackground() {
        stopTimer()
    }
    
    @objc fileprivate func applicationDidBecomeActive() {
        startTimer()
    }
    
    fileprivate func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: Constant.gadMobileAppID)
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID]
        interstitial.load(request)
        return interstitial
    }
    
    fileprivate func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1 * 60, target: self, selector: #selector(showAds), userInfo: self, repeats: true)
    }
    
    fileprivate func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc fileprivate func showAds() {
        if interstitial.isReady, let topController = UIApplication.shared.topMostViewController() {
            interstitial.present(fromRootViewController: topController)
        }
    }
    
}

extension GADManager: GADInterstitialDelegate {
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.interstitial = createAndLoadInterstitial()
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        Logger.log(error.localizedDescription)
    }
}
