//
//  MainTabBarViewController.swift
//  QRCode
//
//  Created by Bao Nguyen on 8/31/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import SwiftQRScanner

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    fileprivate var currentIndex: Int!
    fileprivate var previousIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentIndex = 0
        self.previousIndex = 0
        self.delegate = self
    }
    
    fileprivate func showCamera() {
        let scanner = QRCodeScannerController(cameraImage: #imageLiteral(resourceName: "ic_camera"), cancelImage: #imageLiteral(resourceName: "ic_cancel"), flashOnImage: #imageLiteral(resourceName: "ic_flash_on"), flashOffImage: #imageLiteral(resourceName: "ic_flash_off"))
        scanner.delegate = self
        DispatchQueue.main.async { [unowned self] in
            self.present(scanner, animated: true, completion: nil)
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = self.tabBar.items?.index(of: item) ?? 0
        currentIndex = index
        if currentIndex == 1 {
            showCamera()
        } else {
            previousIndex = index
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
        print(result)
        self.createResult(result)
        self.selectedPreviousTab()
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: String) {
        print(error)
        self.selectedPreviousTab()
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        print("cancel")
        self.selectedPreviousTab()
    }
    
    fileprivate func selectedPreviousTab() {
        self.selectedIndex = previousIndex
    }
    
    fileprivate func createResult(_ content: String) {
        let history = History()
        history.content = content
        try? RealmManager.realm.write {
            RealmManager.realm.add(history)
        }
    }
    
}
