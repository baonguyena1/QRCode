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
import SwipeCellKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak fileprivate var tableView: UITableView!
    @IBOutlet weak var addItemButton: UIBarButtonItem!
    
    fileprivate var historyViewModel: HistoryViewModel!
    fileprivate let bag = DisposeBag()
    fileprivate var histories: Results<History>!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupRx()
        self.setupTableView()
    }
    
    private func setupTableView() {
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
    }
    
    fileprivate func setupRx() {
        self.historyViewModel = HistoryViewModel()
        self.histories = self.historyViewModel.histories
        
        self.historyViewModel.getHistories()
            .subscribe(onNext: { [unowned self] (results, changes) in
                if let changes = changes {
                    self.tableView.applyChangeset(changes)
                } else {
                    self.tableView.reloadData()
                }
            })
            .disposed(by: bag)
        
        self.addItemButton
            .rx.tap
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe{ event in
                
                let history = History()
                var content = ""
                let random = arc4random_uniform(10) % 3
                if random == 0 {
                    content = "https://github.com"
                } else if random == 1 {
                    content = "https://github.com/RxSwiftCommunity/RxRealm"
                } else {
                    content = """
                    https://longurlmaker.com/go?id=87URLHawkTraceURLganglingTightURLstretch0spreadZout147protracted0tall9027Shorl0601MyURL0iDigBig0021protracted6high5bFhURLShorl05s800000FhURL33lofty4lNanoRefq4lofty0v103817great0ShortURL7towering4sdeepuShortURL104i5a0eprolongeda10YepIt7MooURL2URLPieDwarfurlprotractedShortenURLy1lingeringShortURL920running2lengthened01continuedu8ShrtndlengthyWapURL30301URLa132Shortlinks8WapURLSnipURL66stretchingzstretchingb100111stretch1distantbaShortURLj6TraceURLCanURL2b0dfarZoff10URLHawkdistantlnkZinYepIt0c0Shim9a3olankyoe70TinyLinkURLHawk58SnipURL0njprolongedenduring1eifalengthenedFhURLcbYATUCShrinkURL10distantShortlinksspunZoutcFwdURL8171635ca7FhURLlastingcf3653234217ShredURL101outstretchedSnipURLraFhURL0stretchinglongish7PiURLShim5RubyURLdrawnZoutu0clengthyn1enlargedd85URLviShredURL3StartURLgt32mdURLvif15kc0NutshellURLsustainedydrawnZout005protracted40j170aShortlinks017telongated4113NutshellURLe3rDigBigstringyadURLPiem46a0jexpandedlongishGetShorty49GetShortyURLCutterLiteURLprolonged6URLPie0n61protracted37lofty7higheb1TightURL1deepSimURL9h0583great3wn8ggreat2URLZcoZukURLvi2lingering73URlZier19A2N3aURLCutter5ShortenURLUrlTea1prolonged41f00a2stretching08enduring0at140709494070t1zU76Minilien1c5towering3EasyURL101bTraceURL1URLvi3URLCutterFly2088015ShimBeamZto1FwdURLolastingremote4Dwarfurl0farawayjShortURLspreadZout8lengthyf0301URL1Shorld5ospunZout1sstretchxNotLongYATUC053a1926024extensiveSimURLa85ShortenURL4NutshellURL50IsZgdMooURLShortURL301URL11highfarZoffStartURL0IsZgd7enlargedSmallrstretched3jgShrinkrShim0enlarged8EzURL201i11protracted0MyURLqeprotracted83TraceURL064faraway0longishXil914continuedy1U76elongateURLZcoZuk0UrlTea5b001SnipURLSimURLiYepItt011jTinyLink170e301URLlnkZindistant8dloftyeprolongedG8L0e080011longishw0extensiveespreadZoutenduring1URLCutter400a56voenlargedURLZcoZuk7enduringb1tfarZoffstretching31RubyURLStartURLGetShorty05q1104143stringyaa8q2A2NShrinkURL0aRubyURLlengthy296GetShorty4lankyqPiURL10xkrangy0prolonged40lankycstringy10xXilShoterLinksustainedXZse9A2NNotLongShrtndexpandedMinilien640Ulimit1516dShim09Metamark
                    """
                }
                history.content = content
                try? RealmManager.realm.write {
                    RealmManager.realm.add(history)
                }
            }
            .disposed(by: bag)
    }

    // MARK: - Actions
    
}

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as! HistoryCell
        let history = self.histories[indexPath.row]
        cell.history = history
        cell.delegate = self
        return cell
    }
}

extension HistoryViewController: UITableViewDelegate {
    
}

extension HistoryViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let delete = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            let history = self.histories[indexPath.row]
            try? RealmManager.realm.write {
                RealmManager.realm.delete(history)
            }
        }
        self.configure(action: delete)
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .reveal
        options.buttonSpacing = 4
        options.backgroundColor = #colorLiteral(red: 0.9467939734, green: 0.9468161464, blue: 0.9468042254, alpha: 1)
        
        return options
    }
    
    fileprivate func configure(action: SwipeAction) {
        action.title = "Trash"
        action.image = #imageLiteral(resourceName: "trash-circle")
        action.backgroundColor = .clear
        action.textColor = #colorLiteral(red: 1, green: 0.2352941176, blue: 0.1882352941, alpha: 1)
        action.font = .systemFont(ofSize: 13)
        action.transitionDelegate = ScaleTransition.default
    }
}
