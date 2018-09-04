//
//  HistoryViewController.swift
//  QRCode
//
//  Created by Bao Nguyen on 8/30/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import DZNEmptyDataSet
import GoogleMobileAds

class HistoryViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak fileprivate var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    fileprivate var historyViewModel: HistoryViewModel!
    fileprivate let bag = DisposeBag()
    fileprivate lazy var histories = HistoryViewModel.histories

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAds()
        self.setupTableView()
        self.setupRx()
    }
    
    private func setupTableView() {
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView()
    }
    
    fileprivate func setupRx() {
        self.historyViewModel = HistoryViewModel()
        
        self.historyViewModel.getHistories()
            .subscribe(onNext: { [unowned self] (results, changes) in
                if let changes = changes {
                    self.tableView.applyChangeset(changes)
                } else {
                    self.tableView.reloadData()
                }
            })
            .disposed(by: bag)
        
        self.tableView
            .rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                
                let historyDetailController = HistoryDetailViewController.instantiate()
                historyDetailController.history = self.histories[indexPath.row]
                self.navigationController?.pushViewController(historyDetailController, animated: true)
                self.tableView.deselectRow(at: indexPath, animated: true)
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
    
}

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as! HistoryCell
        let history = self.histories[indexPath.row]
        cell.history = history
        return cell
    }
    
}

extension HistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { [unowned self] (action, indexPath) in
            let history = self.histories[indexPath.row]
            try? RealmManager.realm.write {
                RealmManager.realm.delete(history)
            }
        }
        return [delete]
    }
}

extension HistoryViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "placeholder_message")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "When you have messages, you’ll see them here."
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        paragraph.lineSpacing = 4.0
        let attributed: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17),
            NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.8117647059, green: 0.8117647059, blue: 0.8117647059, alpha: 1),
            NSAttributedStringKey.paragraphStyle: paragraph
        ]
        return NSAttributedString(string: text, attributes: attributed)

    }
}
