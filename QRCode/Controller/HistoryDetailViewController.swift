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

class HistoryDetailViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var openURLButton: UIButton!
    @IBOutlet weak var copyButton: UIButton!
    
    fileprivate let bag = DisposeBag()
    fileprivate var historyDetailViewModel: HistoryDetailViewModel!
    
    var history: History!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
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
            .subscribe(onNext: {
                
            })
            .disposed(by: bag)
        
        copyButton
            .rx.tap
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.view.makeToast("Copied to clipboard", duration: 2.0, position: .center)
            })
            .disposed(by: bag)
    }
    
    fileprivate func setupDisplay() {
        self.contentLabel.text = self.history.content
    }

}
