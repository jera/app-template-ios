//
//  CreateAccountViewController.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 22/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit
import RxSwift

class CreateAccountViewController: BaseViewController {
    private var presenterInterfaceBindDisposeBag: DisposeBag!
    var presenterInterface: CreateAccountPresenterInterface?{
        didSet{
            bind()
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        applyAppearance()
        applyTexts()
        
        addCloseButton()
        
        bind()
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white

        guard let createAccountView = R.nib.createAccountView().instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        addScrollView(withSubView: createAccountView)
        
    }
    
    private func applyAppearance(){
//        logoImageView.image = #imageLiteral(resourceName: "ic_logo")
//        
//        doSignWithLabel.textColor = .white
//        doSignWithLabel.font = UIFont.systemFont(ofSize: 14)
//        
//        orLabel.textColor = UIColor(white: 1, alpha: 0.3)
//        orLabel.font = UIFont.systemFont(ofSize: 14)
//        
//        loginButton.applyAppearance(appearance: .main)
//        facebookButton.applyAppearance(appearance: .facebook)
//        googleButton.applyAppearance(appearance: .google)
//        
//        emailTextField.applyAppearance(appearance: .main)
//        passwordTextField.applyAppearance(appearance: .main)
//        
//        createAccountButton.applyAppearance(appearance: .main)
//        
//        forgotPasswordButton.applyAppearance(appearance: .main)
//        
//        emailTextField.keyboardType = .emailAddress
//        emailTextField.autocorrectionType = .no
//        passwordTextField.isSecureTextEntry = true
    }

    private func applyTexts(){
        navigationItem.title = R.string.localizable.createAccountTitle()
//        doSignWithLabel.text = R.string.localizable.loginSignInWith()
//        orLabel.text = R.string.localizable.loginOr()
//        
//        emailTextField.placeholder = R.string.localizable.loginEmail()
//        passwordTextField.placeholder = R.string.localizable.loginPass()
//        loginButton.setTitleWithoutAnimation(R.string.localizable.loginEnter().uppercased(), for: .normal)
//        
//        createAccountButton.setTitleWithoutAnimation(R.string.localizable.loginCreateAccount(), for: .normal)
//        forgotPasswordButton.setTitleWithoutAnimation(R.string.localizable.loginForgotPass(), for: .normal)
    }
    
    private func bind(){
    }
    
    private func addCloseButton(){

        let closeButton = UIBarButtonItem(title: "Voltar", style: .plain, target: nil, action: nil)
        _ = closeButton.rx.tap
            .takeUntil(rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self] (_) in
                self?.presenterInterface?.closeButtonPressed()
            })
        navigationItem.leftBarButtonItems = [closeButton]
    }
}
