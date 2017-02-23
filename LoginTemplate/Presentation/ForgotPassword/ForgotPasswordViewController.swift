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

class ForgotPasswordViewController: BaseViewController {
    
    private var presenterInterfaceBindDisposeBag: DisposeBag!
    var presenterInterface: ForgotPasswordPresenterInterface?{
        didSet{
            bind()
        }
    }
    
    override func loadView() {
        super.loadView()
        
        addScrollView(withSubView: forgotPasswordView) { (forgotPasswordViewLayoutProxy, scrollViewLayoutProxy) in
            forgotPasswordViewLayoutProxy.edges == scrollViewLayoutProxy.edges
            forgotPasswordViewLayoutProxy.width == scrollViewLayoutProxy.width
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.defaultViewBackground()
        
        title = R.string.localizable.forgotPasswordTitleNavBar()
        
        addCloseButton(image: UIImage(named: "ic_nav_back")!) { [weak self] () in
            self?.presenterInterface?.didTapCloseForgotPasswordView()
        }
        
        bind()
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
        
        presenterInterface.emailErrorString
            .subscribe(onNext: { [weak self] (errorString) in
                self?.forgotPasswordView.emailTextField.detail = errorString
            })
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        presenterInterface.forgotPasswordButtonEnabled
            .bindTo(forgotPasswordView.confirmButton.rx.isEnabled)
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        presenterInterface.forgotPasswordRequestResponse
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
                case .success(let message):
                    strongSelf.hideHud()
                    strongSelf.showOKAlertWith(title: "Verifique seu e-mail", message: message ?? "Você receberá um e-mail com instruções sobre como redefinir sua senha.")
                case .cancelled:
                    strongSelf.hideHud()
                }
            })
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
