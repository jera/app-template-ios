//
//  ForgotPasswordViewController.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit
import RxSwift
import Cartography

protocol ForgotPasswordInterface: BaseViewInterface {
    func showLoading()
    func showMessageForgotMyPasswordWith(sucess: String)
    func showMessageForgotMyPasswordWith(error: Error)
}

class ForgotPasswordViewController: BaseViewController {
    
    private var presenterInterfaceBindDisposeBag: DisposeBag!
    var presenterInterface: ForgotPasswordPresenterInterface?{
        didSet{
            bind()
        }
    }
    
    override func loadView() {
        super.loadView()
        
        addForgotPasswordView()
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        addCloseButton(image: UIImage(named: "ic_nav_back")!) { [weak self] () in
            self?.presenterInterface?.didTapCloseForgotPasswordView()
        }
        
        view.backgroundColor = UIColor.defaultViewBackground()
        
        title = "Recuperar senha"
        
        bind()
    }
    
    func addForgotPasswordView(){
        addScrollView(withSubview: forgotPasswordView)
        
        constrain(scrollView, forgotPasswordView) { (scrollView, forgotPasswordView) in
            forgotPasswordView.height == scrollView.height
        }
    }
    
    private func bind(){
        presenterInterfaceBindDisposeBag = DisposeBag()
        
        guard let presenterInterface = presenterInterface else{ return }
        
        presenterInterface.email
            .asObservable()
            .bindTo(forgotPasswordView.emailTextField.rx.text)
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        forgotPasswordView.emailTextField.rx.text
            .asObservable()
            .map { (text) -> String in
                return text ?? ""
            }
            .bindTo(presenterInterface.email)
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        presenterInterface.emailError
            .bindTo(forgotPasswordView.emailErrorLabel.rx.text)
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        presenterInterface.forgotPasswordButtonEnabled
            .bindTo(forgotPasswordView.confirmButton.rx.isEnabled)
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        forgotPasswordView.confirmButton.rx.tap
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                
                strongSelf.presenterInterface?.forgotPasswordPressed()
            }
            .addDisposableTo(presenterInterfaceBindDisposeBag)
    }
    
    private lazy var forgotPasswordView: ForgotPasswordView = {
        let forgotPasswordView = ForgotPasswordView.loadNibName()
        return forgotPasswordView
    }()
    
}

extension ForgotPasswordViewController: ForgotPasswordInterface {
    func showLoading(){
        showHudWith(title:  "Carregando...")
    }
    
    func showMessageForgotMyPasswordWith(sucess: String){
        hideHud()
        showOKAlertWith(title: "Verifique seu e-mail", message: sucess)
    }
    
    func showMessageForgotMyPasswordWith(error: Error){
        hideHud()
        showOKAlertWith(title: "Ops...", message: error.localizedDescription)
    }
}
