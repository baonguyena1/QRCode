//
//  HistoryDetailViewController.swift
//  QRCode
//
//  Created by Bao Nguyen on 8/30/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Toast_Swift
import GoogleMobileAds
import MessageUI

class HistoryDetailViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var openURLButton: UIButton!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    fileprivate let bag = DisposeBag()
    fileprivate var historyDetailViewModel: HistoryDetailViewModel!
    
    var history: History!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
        setupAds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupDisplay()
    }
    
    fileprivate func setupRx() {
        self.historyDetailViewModel = HistoryDetailViewModel()
        
        contentLabel.rx
            .observe(String.self, "text")
            .map { $0 ?? "" }
            .bind(to: historyDetailViewModel.contentVariable)
            .disposed(by: bag)
        
        historyDetailViewModel.contentObservable
            .subscribe(onNext: { (format) in
            
                
        })
        .disposed(by: bag)
        
        openURLButton
            .rx.tap
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                
                let content = self.history.content
                if let url = URL(string: content), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                } else if MFMailComposeViewController.canSendMail() {
                    self.sendEmail(with: content)
                } else if MFMessageComposeViewController.canSendText() {
                    self.sendSMS(with: content)
                }
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
    
    fileprivate func setupDisplay() {
        self.contentLabel.text = self.history.content
    }

}

extension HistoryDetailViewController: MFMailComposeViewControllerDelegate {
    fileprivate func sendEmail(with content: String) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients([content
            ])
        composeVC.setSubject("")
        composeVC.setMessageBody("", isHTML: false)
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension HistoryDetailViewController: MFMessageComposeViewControllerDelegate {
    fileprivate func sendSMS(with content: String) {
        let controller = MFMessageComposeViewController()
        controller.subject = ""
        controller.body = ""
        controller.recipients = [content]
        controller.messageComposeDelegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
