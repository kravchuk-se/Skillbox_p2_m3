//
//  TableViewController.swift
//  Skillbox_m3 (RxSwift)
//
//  Created by Kravchuk Sergey on 14.01.2020.
//  Copyright © 2020 Kravchuk Sergey. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    let bag = DisposeBag()
    
    let names = BehaviorRelay<[String]>(value: [
        "John",
        "Steve",
        "Tim",
        "Bill",
        "Mark"
    ])
    
    let someNames = ["Rocky", "Martin", "Paul", "Jeremy", "Antony"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        names.bind(to: tableView
            .rx
            .items(cellIdentifier: "NameCell", cellType: UITableViewCell.self)) { row, element, cell in
                cell.textLabel?.text = element
            }
            .disposed(by: bag)
        
        addButton
            .rx
            .tap
            .subscribe(onNext: { [unowned self] in
                if let newName = self.someNames.randomElement() {
                    self.names.accept(self.names.value + [newName])
                }
            })
            .disposed(by: bag)
     
        removeButton.rx.tap.subscribe(onNext: { [unowned self] in
                if !self.names.value.isEmpty {
                    var newCollection = self.names.value
                    newCollection.removeLast()
                    self.names.accept(newCollection)
                }
            })
            .disposed(by: bag)
        
        let collectionIsEmpty = names
            .map { $0.isEmpty }
            
        collectionIsEmpty
            .map{ !$0 }
            .bind(to: removeButton.rx.isEnabled)
            .disposed(by: bag)
        
    }
    
    deinit {
        print("deallocation")
    }
    
}
