//
//  RocketLauncherViewController.swift
//  Skillbox_m3 (RxSwift)
//
//  Created by Kravchuk Sergey on 14.01.2020.
//  Copyright © 2020 Kravchuk Sergey. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RocketLauncherViewController: UIViewController {

    @IBOutlet weak var rocketStateLabel: UILabel!
    
    @IBOutlet weak var rocketButton1: UIButton!
    @IBOutlet weak var rocketButton2: UIButton!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rocketStateLabel.text = ""
        
        Observable.combineLatest(rocketButton1.rx.tap, rocketButton2.rx.tap) { [unowned self] _, _ in self.somefunc(); return true }
            .map { $0 ? "Ракета запущена!" : "" }
            .bind(to: rocketStateLabel.rx.text)
            .disposed(by: bag)
        
    }
    
    func somefunc() {
        print("somefunc")
    }
    
    deinit {
        print("deallocation")
    }

}
