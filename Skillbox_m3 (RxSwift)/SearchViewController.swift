//
//  SearchViewController.swift
//  Skillbox_m3 (RxSwift)
//
//  Created by Kravchuk Sergey on 14.01.2020.
//  Copyright © 2020 Kravchuk Sergey. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let bag = DisposeBag()
    
    var requestInProgress = BehaviorRelay(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let searchTerm = searchTextField
            .rx
            .text
            .distinctUntilChanged()
            .map { $0 ?? "" }
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
        
        
        searchTerm.subscribe(onNext: { [unowned self] text in
            
            if text.isEmpty { return }
            
            print("Отправка запроса для \(text)")
            
            self.simulateAsyncRequest(text: text)
            
        })
        .disposed(by: bag)
        
        searchTerm
            .map { "Performing request for: \($0)" }
            .bind(to: stateLabel.rx.text)
            .disposed(by: bag)
        
        requestInProgress
            .map { !$0 }
            .bind(to: stateLabel.rx.isHidden)
            .disposed(by: bag)
        
        requestInProgress
            .asObservable()
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: bag)
        
    }

    func simulateAsyncRequest(text: String) {
        self.requestInProgress.accept(true)
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            DispatchQueue.main.async {
                if self.searchTextField.text != text {
                    // Search text has changed. Some other request must be performing.
                    return
                }
                self.requestInProgress.accept(false)
            }
        }
    }
    
    deinit {
        print("deallocation")
    }
    
}
