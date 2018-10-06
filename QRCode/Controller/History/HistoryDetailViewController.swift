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
import SafariServices

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
                    // Open URL or Call phone
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                } else {
                    if let contentEncode = content.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                        let urlString = "https://www.google.com/search?q=\(contentEncode)"
                        if let url = URL(string: urlString) {
                            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                            vc.delegate = self
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
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

//extension HistoryDetailViewController: MFMailComposeViewControllerDelegate {
//    fileprivate func sendEmail(with content: String) {
//        let composeVC = MFMailComposeViewController()
//        composeVC.mailComposeDelegate = self
//        composeVC.setToRecipients([content
//            ])
//        composeVC.setSubject("")
//        composeVC.setMessageBody("", isHTML: false)
//        self.present(composeVC, animated: true, completion: nil)
//    }
//
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//    }
//}
//
//extension HistoryDetailViewController: MFMessageComposeViewControllerDelegate {
//    fileprivate func sendSMS(with content: String) {
//        let controller = MFMessageComposeViewController()
//        let parseContent = self.parseSMSContent(content: content)
//        controller.subject = parseContent.0
//        controller.body = parseContent.1
//        controller.recipients = parseContent.2
//        controller.messageComposeDelegate = self
//        self.present(controller, animated: true, completion: nil)
//    }
//
//    private func parseSMSContent(content: String) -> (String, String, [String]) {
//        if !content.hasPrefix("MATMSG") || !content.hasPrefix("SMSTO") {
//            return ("", "", [content])
//        }
//        if content.hasPrefix("MATMSG") {
//            let start = content.index(content.startIndex, offsetBy: "MATMSG".count + 1)
//            let mainContent = content[start...] as NSString
//
//            var startIndex = mainContent.range(of: "TO:").upperBound
//            var endIndex = mainContent.range(of: ";SUB:").lowerBound
//            var range = NSMakeRange(startIndex, endIndex - startIndex)
//            let recipients = mainContent.substring(with: range).components(separatedBy: ",")
//
//            startIndex = mainContent.range(of: ";SUB:").upperBound
//            endIndex = mainContent.range(of: ";BODY:").lowerBound
//            range = NSMakeRange(startIndex, endIndex - startIndex)
//            let sub = mainContent.substring(with: range)
//
//            startIndex = mainContent.range(of: ";BODY:").upperBound
//            endIndex = mainContent.range(of: ";;").lowerBound
//            range = NSMakeRange(startIndex, endIndex - startIndex)
//            let body = mainContent.substring(with: range)
//            return (sub, body, recipients)
//        }
//        if content.hasPrefix("SMSTO") {
//            let start = content.index(content.startIndex, offsetBy: "SMSTO".count + 1)
//            let mainContent = content[start...] as NSString
//
//        }
//        return ("", "", [])
//    }
//
//    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
//        controller.dismiss(animated: true, completion: nil)
//    }
//}


extension HistoryDetailViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
