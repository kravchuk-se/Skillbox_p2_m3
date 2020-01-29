//
//  CounterViewController.swift
//  Skillbox_m3 (RxSwift)
//
//  Created by Kravchuk Sergey on 14.01.2020.
//  Copyright © 2020 Kravchuk Sergey. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CounterViewController: UIViewController {

    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    let bag = DisposeBag()
    
    let counter = BehaviorRelay(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = addButton.bounds.width / 2
        
        counter
            .map { String(format: "%01d", $0) }
            .bind(to: counterLabel
                .rx
                .text)
            .disposed(by: bag)
        
        addButton
            .rx
            .tap
            .subscribe(onNext: { [unowned self] in
                self.counter.accept(self.counter.value + 1)
            })
            .disposed(by: bag)
        
    }
    
    deinit {
        print("deallocation")
    }
    
}
