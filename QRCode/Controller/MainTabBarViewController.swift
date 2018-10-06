//
//  MainTabBarViewController.swift
//  QRCode
//
//  Created by Bao Nguyen on 8/31/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import SwiftQRScanner
import AudioToolbox

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    fileprivate var currentIndex: Int!
    fileprivate var previousIndex: Int!
    
    let strSoundFile = Bundle.main.path(forResource: "1801", ofType: "wav")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentIndex = 0
        self.previousIndex = 0
        self.delegate = self
    }
    
    private func showCamera() {
        let scanner = QRCodeScannerController(cameraImage: #imageLiteral(resourceName: "ic_camera"), cancelImage: #imageLiteral(resourceName: "ic_cancel"), flashOnImage: #imageLiteral(resourceName: "ic_flash_on"), flashOffImage: #imageLiteral(resourceName: "ic_flash_off"))
        scanner.delegate = self
        let navigation = UINavigationController(rootViewController: scanner)
        navigation.navigationBar.isHidden = true
        DispatchQueue.main.async { [unowned self] in
            self.present(navigation, animated: true, completion: nil)
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = self.tabBar.items?.index(of: item) ?? 0
        self.currentIndex = index
        if self.currentIndex == 1 {
            self.showCamera()
        } else {
            self.previousIndex = index
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.isKind(of: UINavigationController.self) {
            return true
        }
        return false
    }
}

extension MainTabBarViewController: QRScannerCodeDelegate {
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        self.playSound()
        self.createResult(result)
        self.selectedPreviousTab()
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: String) {
        self.selectedPreviousTab()
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        self.selectedPreviousTab()
    }
}

extension MainTabBarViewController {
    
    fileprivate func selectedPreviousTab() {
        self.selectedIndex = previousIndex
    }
    
    fileprivate func createResult(_ content: String) {
        if let history = History.object(with: content) {
            RealmManager.update {
                history.createdDate = Date()
            }
        } else {
            let history = History()
            history.content = content
            RealmManager.add(object: history)
        }
    }
    
    fileprivate func playSound() {
        if AppSetting.shared.isSoundOn {
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(URL(fileURLWithPath: strSoundFile!) as CFURL, &soundID)
            AudioServicesPlaySystemSound(soundID)
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    }
}
