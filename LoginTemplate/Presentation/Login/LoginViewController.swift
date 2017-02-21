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
import Cartography

class LoginViewController: BaseViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var emailErrorLabel: UILabel!
    
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordErrorLabel: UILabel!
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var facebookButton: UIButton!
    @IBOutlet private weak var googleButton: UIButton!
    
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
    
    override func loadView() {
        super.loadView()
        
        addBackgroundImageView(withImage: #imageLiteral(resourceName: "img_bg"))
        
        guard let loginView = Bundle.main.loadNibNamed("LoginView", owner: self, options: nil)?.first as? UIView else {
            print("No LoginView")
            return
        }
        addScrollView(withSubView: loginView)

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
        
        presenterInterface.loginRequestResponse
            .subscribe(onNext: { [weak self] (requestResponse) in
                guard let strongSelf = self else { return }
                
                switch requestResponse{
                case .new:
                    strongSelf.hideHud()
                case .loading:
                    strongSelf.showHudWith(title:  "Entrando...")
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
        
        presenterInterface.facebookRequestResponse
            .subscribe(onNext: { [weak self] (requestResponse) in
                guard let strongSelf = self else { return }
                
                switch requestResponse{
                case .new:
                    strongSelf.hideHud()
                case .loading:
                    strongSelf.showHudWith(title:  "Entrando com Facebook...")
                    break
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
        
        presenterInterface.googleRequestResponse
            .subscribe(onNext: { [weak self] (requestResponse) in
                guard let strongSelf = self else { return }
                
                switch requestResponse{
                case .new:
                    strongSelf.hideHud()
                case .loading:
                    strongSelf.showHudWith(title:  "Entrando com Google...")
                    break
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
        
        //Buttons Action
        loginButton.rx.tap
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                
                strongSelf.presenterInterface?.loginButtonPressed()
            }
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        facebookButton.rx.tap
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                
                strongSelf.presenterInterface?.facebookLoginButtonPressed(presenterViewController: strongSelf)
            }
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        googleButton.rx.tap
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                
                strongSelf.presenterInterface?.googleLoginButtonPressed(presenterViewController: strongSelf)
            }
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
    }
    
}
