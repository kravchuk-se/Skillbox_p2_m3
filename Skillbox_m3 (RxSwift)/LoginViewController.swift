//
//  LoginViewController.swift
//  Skillbox_m3 (RxSwift)
//
//  Created by Kravchuk Sergey on 14.01.2020.
//  Copyright © 2020 Kravchuk Sergey. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    private enum State {
        case correct
        case invalidEmail
        case shortPassword
        init(emailIsValid: Bool, passwordIsValid: Bool) {
            if !emailIsValid {
                self = .invalidEmail
            } else if !passwordIsValid {
                self = .shortPassword
            } else {
                self = .correct
            }
        }
        
        var warningMessage: String? {
            switch self {
            case .correct:
                return nil
            case .invalidEmail:
                return "Некорректная почта"
            case .shortPassword:
                return "Слишком короткий пароль"
            }
        }
        
    }
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBOutlet weak var sendButton: UIButton!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginIsValid = loginTextField
            .rx
            .text
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .map{ [unowned self] in
                self.validate(email: $0)
            }
        let passwordIsValid = passwordTextField
            .rx
            .text
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .map { [unowned self] in
                self.validate(password: $0)
            }
        
        Observable.combineLatest(loginIsValid, passwordIsValid) {
            return State(emailIsValid: $0, passwordIsValid: $1)
        }
        .subscribe(onNext: { [unowned self] value in
            
            self.warningLabel.text = value.warningMessage
            self.sendButton.isEnabled = value == .correct
            
        })
        .disposed(by: bag)
        
    }
    
    func validate(email: String?) -> Bool {
        guard let email = email else { return false }
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let regexp = try! NSRegularExpression(pattern: emailRegEx)
        let matches = regexp.matches(in: email, range: NSRange(location: 0, length: email.count))
        return matches.count > 0
    }
    
    func validate(password: String?) -> Bool {
        guard let password = password else { return false }
        return password.count >= 6
    }
    
    deinit {
        print("deallocation")
    }
    
}
