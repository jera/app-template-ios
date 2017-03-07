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
import Material

class ForgotPasswordViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var confirmButton: RaisedButton!
    
    private var presenterInterfaceBindDisposeBag: DisposeBag!
    var presenterInterface: ForgotPasswordPresenterInterface?{
        didSet{
            bind()
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        applyAppearance()
        applyTexts()
        
        addCloseButton(image: UIImage(named: "ic_nav_back")!) { [weak self] () in
            self?.presenterInterface?.didTapCloseForgotPasswordView()
        }
        
        bind()
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
        guard let forgotPasswordView = R.nib.forgotPasswordView().instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        addScrollView(withSubView: forgotPasswordView){ (forgotPasswordViewLayoutProxy, scrollViewLayoutProxy) in
            forgotPasswordViewLayoutProxy.edges == scrollViewLayoutProxy.edges
            forgotPasswordViewLayoutProxy.width == scrollViewLayoutProxy.width
        }
    }
    
    private func applyAppearance(){
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        
        emailTextField.applyAppearance(appearance: .white)
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        
        confirmButton.applyAppearance(appearance: .main)
        confirmButton.layer.cornerRadius = 5
    }
    
    private func applyTexts(){
        title = R.string.localizable.forgotPasswordTitleNavBar()
        
        titleLabel.text = R.string.localizable.forgotPasswordTitle()
        emailTextField.placeholder = R.string.localizable.defaultEmail()
        confirmButton.setTitleWithoutAnimation(R.string.localizable.forgotPasswordSend().uppercased(), for: .normal)
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
        
        presenterInterface.forgotPasswordButtonEnabled
            .bindTo(confirmButton.rx.isEnabled)
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        presenterInterface.forgotPasswordRequestResponse
            .subscribe(onNext: { [weak self] (requestResponse) in
                guard let strongSelf = self else { return }
                
                switch requestResponse{
                case .new:
                    strongSelf.hideHud()
                case .loading:
                    strongSelf.showHudWith(title:  R.string.localizable.alertLoading())
                case .failure(let error):
                    strongSelf.hideHud()
                    strongSelf.showOKAlertWith(title: R.string.localizable.alertTitle(), message: error.localizedDescription)
                case .success(let message):
                    strongSelf.hideHud()
                    strongSelf.showOKAlertWith(title: R.string.localizable.forgotPasswordCheckYourEmail(), message: message ?? R.string.localizable.forgotPasswordMessage())
                case .cancelled:
                    strongSelf.hideHud()
                }
            })
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        confirmButton.rx.tap
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                
                strongSelf.presenterInterface?.forgotPasswordPressed()
            }
            .addDisposableTo(presenterInterfaceBindDisposeBag)
    }
    
}
