//
//  LoginViewController.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    private var presenterInterfaceBindDisposeBag: DisposeBag!
    var presenterInterface: LoginPresenterInterface?{
        didSet{
            bind()
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind(){
        guard isLoaded else { return }
        
        presenterInterfaceBindDisposeBag = DisposeBag()
        
        guard let presenterInterface = presenterInterface else{ return }
        
        presenterInterface.email
            .asObservable()
            .bindTo(emailTextField.rx.text)
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        emailTextField.rx.text
            .asObservable()
            .map { (text) -> String in
                return text ?? ""
            }
            .bindTo(presenterInterface.email)
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        presenterInterface.emailErrorString
            .bindTo(emailErrorLabel.rx.text)
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        presenterInterface.password
            .asObservable()
            .bindTo(passwordTextField.rx.text)
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        passwordTextField.rx.text
            .asObservable()
            .map { (text) -> String in
                return text ?? ""
            }
            .bindTo(presenterInterface.password)
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        presenterInterface.passwordErrorString
            .bindTo(passwordErrorLabel.rx.text)
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        presenterInterface.loginButtonEnabled
            .bindTo(loginButton.rx.isEnabled)
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        loginButton.rx.tap
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                
                strongSelf.presenterInterface?.loginButtonPressed()
            }
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        presenterInterface.loginRequestResponse
            .subscribe(onNext: { [weak self] (requestResponse) in
                guard let strongSelf = self else { return }
                
                switch requestResponse{
                case .new:
                    strongSelf.hideHud()
                case .loading:
                    strongSelf.showHudWith(title:  "Carregando...")
                case .failure(let error):
                    strongSelf.hideHud()
                    strongSelf.showOKAlertWith(title: "Ops...", message: error.localizedDescription)
                case .success:
                    strongSelf.hideHud()
                case .cancelled:
                    strongSelf.hideHud()
                }
            })
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
    }
    
}
