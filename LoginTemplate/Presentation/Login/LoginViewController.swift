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
import Material

class LoginViewController: BaseViewController {

    @IBOutlet private weak var logoImageView: UIImageView!
    
    @IBOutlet private weak var doSignWithLabel: UILabel!
    
    @IBOutlet private weak var emailTextField: TextField!
    
    @IBOutlet private weak var passwordTextField: TextField!
    
    @IBOutlet private weak var orLabel: UILabel!
    
    @IBOutlet private weak var loginButton: RaisedButton!
    @IBOutlet private weak var facebookButton: RaisedButton!
    @IBOutlet private weak var googleButton: RaisedButton!
    
    @IBOutlet private weak var createAccountButton: FlatButton!
    @IBOutlet private weak var forgotPasswordButton: FlatButton!
    
    private var presenterInterfaceBindDisposeBag: DisposeBag!
    var presenterInterface: LoginPresenterInterface?{
        didSet{
            bind()
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        applyAppearance()
        applyTexts()
        
        bind()
    }
    
    override func loadView() {
        super.loadView()
        
        addBackgroundImageView(withImage: #imageLiteral(resourceName: "img_bg"))
        
        guard let loginView = R.nib.loginView().instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        addScrollView(withSubView: loginView) { [weak self] (loginViewLayoutProxy, scrollViewLayoutProxy) in
            guard let strongSelf = self else { return }
            
            loginViewLayoutProxy.top == scrollViewLayoutProxy.top ~ 1
            loginViewLayoutProxy.bottom == scrollViewLayoutProxy.bottom ~ 1
            
            if strongSelf.view.frame.height > loginView.frame.height{
                loginViewLayoutProxy.centerY == scrollViewLayoutProxy.centerY
            }
            
            loginViewLayoutProxy.left == scrollViewLayoutProxy.left
            loginViewLayoutProxy.right == scrollViewLayoutProxy.right
            
            loginViewLayoutProxy.width == scrollViewLayoutProxy.width
        }

    }
    
    private func applyAppearance(){
        logoImageView.image = #imageLiteral(resourceName: "ic_logo")
        
        doSignWithLabel.textColor = .white
        doSignWithLabel.font = UIFont.systemFont(ofSize: 14)
        
        orLabel.textColor = UIColor(white: 1, alpha: 0.3)
        orLabel.font = UIFont.systemFont(ofSize: 14)
        
        loginButton.applyAppearance(appearance: .main)
        facebookButton.applyAppearance(appearance: .facebook)
        googleButton.applyAppearance(appearance: .google)
        
        emailTextField.applyAppearance(appearance: .main)
        passwordTextField.applyAppearance(appearance: .main)
        
        createAccountButton.applyAppearance(appearance: .main)
        
        forgotPasswordButton.applyAppearance(appearance: .main)
        
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        passwordTextField.isSecureTextEntry = true
    }
    
    private func applyTexts(){
        doSignWithLabel.text = R.string.localizable.loginSignInWith()
        orLabel.text = R.string.localizable.loginOr()
        
        emailTextField.placeholder = R.string.localizable.defaultEmail()
        passwordTextField.placeholder = R.string.localizable.loginPass()
        loginButton.setTitleWithoutAnimation(R.string.localizable.loginEnter().uppercased(), for: .normal)
        
        createAccountButton.setTitleWithoutAnimation(R.string.localizable.loginCreateAccount(), for: .normal)
        forgotPasswordButton.setTitleWithoutAnimation(R.string.localizable.loginForgotPass(), for: .normal)
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
            .subscribe(onNext: { [weak self] (errorString) in
                self?.emailTextField.detail = errorString
            })
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
            .subscribe(onNext: { [weak self] (errorString) in
                self?.passwordTextField.detail = errorString
            })
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
                    strongSelf.showHudWith(title:  R.string.localizable.loginLoging())
                case .failure(let error):
                    strongSelf.hideHud()
                    strongSelf.showOKAlertWith(title: R.string.localizable.alertTitle(), message: error.localizedDescription)
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
                    strongSelf.showHudWith(title: R.string.localizable.loginLogingWithFacebook())
                    break
                case .failure(let error):
                    strongSelf.hideHud()
                    strongSelf.showOKAlertWith(title: R.string.localizable.alertTitle(), message: error.localizedDescription)
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
                    strongSelf.showHudWith(title:  R.string.localizable.loginLogingWithGoogle())
                    break
                case .failure(let error):
                    strongSelf.hideHud()
                    strongSelf.showOKAlertWith(title: R.string.localizable.alertTitle(), message: error.localizedDescription)
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
        
        forgotPasswordButton.rx.tap
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                
                strongSelf.presenterInterface?.forgotPasswordButtonPressed()
            }
            .addDisposableTo(presenterInterfaceBindDisposeBag)
                
        createAccountButton.rx.tap
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                
                strongSelf.presenterInterface?.createAccountButtonPressed()
            }
            .addDisposableTo(presenterInterfaceBindDisposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
}
