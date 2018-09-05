//
//  PhotoViewController.swift
//  QRCode
//
//  Created by Bao Nguyen on 9/5/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import GoogleMobileAds
import YPImagePicker
import RxSwift
import RxCocoa

class PhotoViewController: UIViewController {

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var readButton: UIBarButtonItem!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var copyButton: UIButton!
    
    fileprivate let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRx()
        setupAds()
        contentLabel.text = """
                Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
            """
    }
    
    fileprivate func setupRx() {
        readButton
            .rx.tap
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.showImageBrowser()
            })
            .disposed(by: bag)
        
        openButton
            .rx.tap
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                
            })
            .disposed(by: bag)
        
        copyButton
            .rx.tap
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                UIPasteboard.general.string = self.contentLabel.text
                self.view.makeToast("Copied to clipboard", duration: 1.0, position: .center)
            })
            .disposed(by: bag)
    }

    fileprivate func setupAds() {
        bannerView.adUnitID = Constant.gadMobileAppID
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)
    }
    
    fileprivate func showImageBrowser() {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photoAndVideo
        config.library.onlySquare  = false
        config.onlySquareImagesFromCamera = true
        config.targetImageSize = .original
        config.usesFrontCamera = true
        config.showsFilters = false
        config.shouldSaveNewPicturesToAlbum = true
        config.screens = [.library, .photo]
        config.startOnScreen = .library
        config.showsCrop = .rectangle(ratio: (16/9))
        config.hidesStatusBar = false
        config.isScrollToChangeModesEnabled = false
        
        // Build a picker with your configuration
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] (items, cancelled) in
            if let photo = items.singlePhoto {
                self.iconImageView.image = photo.image
            }
            // MARK: - Read QRCode
            picker.dismiss(animated: true, completion: nil)
        }
        DispatchQueue.main.async { [unowned self] in
            self.present(picker, animated: true, completion: nil)
        }
    }
    
}
