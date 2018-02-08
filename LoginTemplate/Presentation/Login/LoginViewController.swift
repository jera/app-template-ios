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
    
    private var disposeBag: DisposeBag!
    var presenter: LoginPresenterProtocol? {
        didSet {
            bind()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyAppearance()
        applyTexts()
        
        bind()
    }
    
    override func loadView() {
        super.loadView()
        
        addBackgroundImageView(withImage: Appearance.backgroundImage)
        
        guard let loginView = R.nib.loginView().instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        addScrollView(withSubView: loginView) { [weak self] (loginViewLayoutProxy, scrollViewLayoutProxy) in
            guard let strongSelf = self else { return }
            
            loginViewLayoutProxy.top == scrollViewLayoutProxy.top ~ 1
            loginViewLayoutProxy.bottom == scrollViewLayoutProxy.bottom ~ 1
            
            if strongSelf.view.frame.height > loginView.frame.height {
                loginViewLayoutProxy.centerY == scrollViewLayoutProxy.centerY
            }
            
            loginViewLayoutProxy.left == scrollViewLayoutProxy.left
            loginViewLayoutProxy.right == scrollViewLayoutProxy.right
            
            loginViewLayoutProxy.width == scrollViewLayoutProxy.width
        }

    }
    
    private func applyAppearance() {
        logoImageView.image = Appearance.logoImage
        
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
    
    private func applyTexts() {
        doSignWithLabel.text = R.string.localizable.loginSignInWith()
        orLabel.text = R.string.localizable.loginOr()
        
        emailTextField.placeholder = R.string.localizable.defaultEmail()
        passwordTextField.placeholder = R.string.localizable.loginPass()
        loginButton.setTitleWithoutAnimation(R.string.localizable.loginEnter().uppercased(), for: .normal)
        
        createAccountButton.setTitleWithoutAnimation(R.string.localizable.loginCreateAccount(), for: .normal)
        forgotPasswordButton.setTitleWithoutAnimation(R.string.localizable.loginForgotPass(), for: .normal)
    }
    
    private func bind() {
        guard isLoaded else { return }
        
        disposeBag = DisposeBag()
        
        guard let presenter = presenter else { return }
        
        presenter.email
            .asObservable()
            .bind(to: emailTextField.rx.text)
            .addDisposableTo(disposeBag)
        
        emailTextField.rx.text
            .asObservable()
            .map { (text) -> String in
                return text ?? ""
            }
            .bind(to: presenter.email)
            .addDisposableTo(disposeBag)
        
        presenter.emailErrorString
            .subscribe(onNext: { [weak self] (errorString) in
                self?.emailTextField.detail = errorString
            })
            .addDisposableTo(disposeBag)
        
        presenter.password
            .asObservable()
            .bind(to: passwordTextField.rx.text)
            .addDisposableTo(disposeBag)
        
        passwordTextField.rx.text
            .asObservable()
            .map { (text) -> String in
                return text ?? ""
            }
            .bind(to: presenter.password)
            .addDisposableTo(disposeBag)
        
        presenter.passwordErrorString
            .subscribe(onNext: { [weak self] (errorString) in
                self?.passwordTextField.detail = errorString
            })
            .addDisposableTo(disposeBag)
        
        presenter.loginButtonEnabled
            .bind(to: loginButton.rx.isEnabled)
            .addDisposableTo(disposeBag)
        
        presenter.loginRequestResponse
            .subscribe(onNext: { [weak self] (requestResponse) in
                guard let strongSelf = self else { return }
                
                switch requestResponse {
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
            .addDisposableTo(disposeBag)
        
        presenter.facebookRequestResponse
            .subscribe(onNext: { [weak self] (requestResponse) in
                guard let strongSelf = self else { return }
                
                switch requestResponse {
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
            .addDisposableTo(disposeBag)
        
        presenter.googleRequestResponse
            .subscribe(onNext: { [weak self] (requestResponse) in
                guard let strongSelf = self else { return }
                
                switch requestResponse {
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
            .addDisposableTo(disposeBag)
        
        //Buttons Action
        loginButton.rx.tap
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                
                strongSelf.presenter?.loginButtonPressed()
            }
            .addDisposableTo(disposeBag)
        
        facebookButton.rx.tap
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                
                strongSelf.presenter?.facebookLoginButtonPressed(presenterViewController: strongSelf)
            }
            .addDisposableTo(disposeBag)
        
        googleButton.rx.tap
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                
                strongSelf.presenter?.googleLoginButtonPressed(presenterViewController: strongSelf)
            }
            .addDisposableTo(disposeBag)
        
        forgotPasswordButton.rx.tap
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                
                strongSelf.presenter?.forgotPasswordButtonPressed()
            }
            .addDisposableTo(disposeBag)
                
        createAccountButton.rx.tap
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                
                strongSelf.presenter?.createAccountButtonPressed()
            }
            .addDisposableTo(disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
