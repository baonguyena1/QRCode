//
//  ViewController.swift
//  QRCode
//
//  Created by Bao Nguyen on 8/31/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import SwiftQRScanner

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func click(_ sender: UIButton) {
        let scanner = QRCodeScannerController(cameraImage: #imageLiteral(resourceName: "ic_camera"), cancelImage: #imageLiteral(resourceName: "ic_cancel"), flashOnImage: #imageLiteral(resourceName: "ic_flash_on"), flashOffImage: #imageLiteral(resourceName: "ic_flash_off"))
        scanner.delegate = self
        self.present(scanner, animated: true, completion: nil)
    }
}

extension ViewController: QRScannerCodeDelegate {
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        print(result)
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: String) {
        print(error)
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        print("cancel")
    }

}
