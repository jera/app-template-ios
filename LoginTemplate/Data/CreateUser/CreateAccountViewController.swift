//
//  CreateAccountViewController.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 22/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit
import RxSwift
import Material
import Cartography

class CreateAccountViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: TextField!
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var phoneTextField: MaskTextField!
    @IBOutlet weak var cpfTextField: MaskTextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var confirmPasswordTextField: TextField!
    
    @IBOutlet weak var changePhotoButton: FlatButton!
    @IBOutlet weak var createAccountButton: RaisedButton!
    
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
        
        addCloseButton(image: UIImage(named: "ic_nav_back")!) { [weak self] () in
            self?.presenterInterface?.closeButtonPressed()
        }
        
        bind()
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white

        guard let createAccountView = R.nib.createAccountView().instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        addScrollView(withSubView: createAccountView){ (createAccountViewLayoutProxy, scrollViewLayoutProxy) in
            createAccountViewLayoutProxy.edges == scrollViewLayoutProxy.edges
            createAccountViewLayoutProxy.width == scrollViewLayoutProxy.width
        }
    }
    
    
    private func applyAppearance(){
//        avatarImageView.image = UIImage(named: "avatar")
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderColor = UIColor(white: 190/255, alpha: 1).cgColor
        avatarImageView.layer.borderWidth = 2.0
        
        nameTextField.applyAppearance(appearance: .white)
        nameTextField.autocorrectionType = .no
        nameTextField.autocapitalizationType = .words
        
        emailTextField.applyAppearance(appearance: .white)
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        
        phoneTextField.applyAppearance(appearance: .white)
        phoneTextField.keyboardType = .numberPad
        phoneTextField.fieldMask = .phone
        
        cpfTextField.applyAppearance(appearance: .white)
        cpfTextField.keyboardType = .numberPad
        cpfTextField.fieldMask = .cpf
        
        passwordTextField.applyAppearance(appearance: .white)
        passwordTextField.isSecureTextEntry = true
        
        confirmPasswordTextField.applyAppearance(appearance: .white)
        confirmPasswordTextField.isSecureTextEntry = true
        
        changePhotoButton.applyAppearance(appearance: .white)
        
        createAccountButton.applyAppearance(appearance: .main)
        createAccountButton.backgroundColor = UIColor.defaultBackgroundButton()
        createAccountButton.layer.cornerRadius = 5
    }

    private func applyTexts(){
        title = R.string.localizable.createAccountTitle()
        
        nameTextField.placeholder = R.string.localizable.createAccountName()
        emailTextField.placeholder = R.string.localizable.defaultEmail()
        phoneTextField.placeholder = R.string.localizable.createAccountPhone()
        cpfTextField.placeholder = R.string.localizable.createAccountCpf()
        passwordTextField.placeholder = R.string.localizable.createAccountPassword()
        confirmPasswordTextField.placeholder = R.string.localizable.createAccountConfirmPassword()
        
        changePhotoButton.setTitleWithoutAnimation(R.string.localizable.createAccountSeachPhoto(), for: .normal)
        createAccountButton.setTitleWithoutAnimation(R.string.localizable.createAccountFinishRegister(), for: .normal)
    }
    
    private func bind(){
        guard isLoaded else { return }
        
        presenterInterfaceBindDisposeBag = DisposeBag()
        
        guard let presenterInterface = presenterInterface else{ return }
        
        presenterInterface.userImage
            .map { (userImage) -> UIImage in
                return userImage ?? #imageLiteral(resourceName: "avatar")
            }
            .bindTo(avatarImageView.rx.image)
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        presenterInterface.name
            .asObservable()
            .bindTo(nameTextField.rx.text)
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        nameTextField.rx.text
            .asObservable()
            .map { (text) -> String in
                return text ?? ""
            }
            .bindTo(presenterInterface.name)
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        presenterInterface.nameErrorString
            .subscribe(onNext: { [weak self] (errorString) in
                self?.nameTextField.detail = errorString
            })
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
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
        
        presenterInterface.phone
            .asObservable()
            .bindTo(phoneTextField.rx.text)
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        phoneTextField.rawTextObservable
            .bindTo(presenterInterface.phone)
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        presenterInterface.phoneErrorString
            .subscribe(onNext: { [weak self] (errorString) in
                self?.phoneTextField.detail = errorString
            })
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        presenterInterface.cpf
            .asObservable()
            .bindTo(cpfTextField.rx.text)
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        cpfTextField.rawTextObservable
            .bindTo(presenterInterface.cpf)
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        presenterInterface.cpfErrorString
            .subscribe(onNext: { [weak self] (errorString) in
                self?.cpfTextField.detail = errorString
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
        
        presenterInterface.passwordConfirm
            .asObservable()
            .bindTo(confirmPasswordTextField.rx.text)
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        confirmPasswordTextField.rx.text
            .asObservable()
            .map { (text) -> String in
                return text ?? ""
            }
            .bindTo(presenterInterface.passwordConfirm)
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        presenterInterface.passwordConfirmErrorString
            .subscribe(onNext: { [weak self] (errorString) in
                self?.confirmPasswordTextField.detail = errorString
            })
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        presenterInterface.createAccountButtonEnabled
            .bindTo(createAccountButton.rx.isEnabled)
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        presenterInterface.createAccountRequestResponse
            .subscribe(onNext: { [weak self] (requestResponse) in
                guard let strongSelf = self else { return }
                
                switch requestResponse{
                case .new:
                    strongSelf.hideHud()
                case .loading:
                    strongSelf.showHudWith(title:  R.string.localizable.alertWait())
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
        
        changePhotoButton.rx.tap
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                
                strongSelf.presenterInterface?.chooseUserImageButtonPressed()
            }
            .addDisposableTo(presenterInterfaceBindDisposeBag)
        
        createAccountButton.rx.tap
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                
                strongSelf.presenterInterface?.createButtonPressed()
            }
            .addDisposableTo(presenterInterfaceBindDisposeBag)
    }
}
