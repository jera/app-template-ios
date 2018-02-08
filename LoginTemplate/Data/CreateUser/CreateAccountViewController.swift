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
    
    private var presenterBindDisposeBag: DisposeBag!
    var presenter: CreateAccountPresenterProtocol? {
        didSet {
            bind()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyAppearance()
        applyTexts()
        
        addCloseButton(image: UIImage(named: "ic_nav_back")!) { [weak self] () in
            self?.presenter?.closeButtonPressed()
        }
        
        bind()
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white

        guard let createAccountView = R.nib.createAccountView().instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        addScrollView(withSubView: createAccountView) { (createAccountViewLayoutProxy, scrollViewLayoutProxy) in
            createAccountViewLayoutProxy.edges == scrollViewLayoutProxy.edges
            createAccountViewLayoutProxy.width == scrollViewLayoutProxy.width
        }
    }
    
    private func applyAppearance() {
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

    private func applyTexts() {
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
    
    private func bind() {
        guard isLoaded else { return }
        
        presenterBindDisposeBag = DisposeBag()
        
        guard let presenter = presenter else { return }
        
        presenter.userImage
            .map { (userImage) -> UIImage in
                return userImage ?? #imageLiteral(resourceName: "avatar")
            }
            .bind(to: avatarImageView.rx.image)
            .addDisposableTo(presenterBindDisposeBag)
        
        presenter.name
            .asObservable()
            .bind(to: nameTextField.rx.text)
            .addDisposableTo(presenterBindDisposeBag)
        
        nameTextField.rx.text
            .asObservable()
            .map { (text) -> String in
                return text ?? ""
            }
            .bind(to: presenter.name)
            .addDisposableTo(presenterBindDisposeBag)
        
        presenter.nameErrorString
            .subscribe(onNext: { [weak self] (errorString) in
                self?.nameTextField.detail = errorString
            })
            .addDisposableTo(presenterBindDisposeBag)
        
        presenter.email
            .asObservable()
            .bind(to: emailTextField.rx.text)
            .addDisposableTo(presenterBindDisposeBag)
        
        emailTextField.rx.text
            .asObservable()
            .map { (text) -> String in
                return text ?? ""
            }
            .bind(to: presenter.email)
            .addDisposableTo(presenterBindDisposeBag)
        
        presenter.emailErrorString
            .subscribe(onNext: { [weak self] (errorString) in
                self?.emailTextField.detail = errorString
            })
            .addDisposableTo(presenterBindDisposeBag)
        
        presenter.phone
            .asObservable()
            .bind(to: phoneTextField.rx.text)
            .addDisposableTo(presenterBindDisposeBag)
        
        phoneTextField.rawTextObservable
            .bind(to: presenter.phone)
            .addDisposableTo(presenterBindDisposeBag)
        
        presenter.phoneErrorString
            .subscribe(onNext: { [weak self] (errorString) in
                self?.phoneTextField.detail = errorString
            })
            .addDisposableTo(presenterBindDisposeBag)
        
        presenter.cpf
            .asObservable()
            .bind(to: cpfTextField.rx.text)
            .addDisposableTo(presenterBindDisposeBag)
        
        cpfTextField.rawTextObservable
            .bind(to: presenter.cpf)
            .addDisposableTo(presenterBindDisposeBag)
        
        presenter.cpfErrorString
            .subscribe(onNext: { [weak self] (errorString) in
                self?.cpfTextField.detail = errorString
            })
            .addDisposableTo(presenterBindDisposeBag)
        
        presenter.password
            .asObservable()
            .bind(to: passwordTextField.rx.text)
            .addDisposableTo(presenterBindDisposeBag)
        
        passwordTextField.rx.text
            .asObservable()
            .map { (text) -> String in
                return text ?? ""
            }
            .bind(to: presenter.password)
            .addDisposableTo(presenterBindDisposeBag)
        
        presenter.passwordErrorString
            .subscribe(onNext: { [weak self] (errorString) in
                self?.passwordTextField.detail = errorString
            })
            .addDisposableTo(presenterBindDisposeBag)
        
        presenter.passwordConfirm
            .asObservable()
            .bind(to: confirmPasswordTextField.rx.text)
            .addDisposableTo(presenterBindDisposeBag)
        
        confirmPasswordTextField.rx.text
            .asObservable()
            .map { (text) -> String in
                return text ?? ""
            }
            .bind(to: presenter.passwordConfirm)
            .addDisposableTo(presenterBindDisposeBag)
        
        presenter.passwordConfirmErrorString
            .subscribe(onNext: { [weak self] (errorString) in
                self?.confirmPasswordTextField.detail = errorString
            })
            .addDisposableTo(presenterBindDisposeBag)
        
        presenter.createAccountButtonEnabled
            .bind(to: createAccountButton.rx.isEnabled)
            .addDisposableTo(presenterBindDisposeBag)
        
        presenter.createAccountRequestResponse
            .subscribe(onNext: { [weak self] (requestResponse) in
                guard let strongSelf = self else { return }
                
                switch requestResponse {
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
            .addDisposableTo(presenterBindDisposeBag)
        
        changePhotoButton.rx.tap
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                
                strongSelf.presenter?.chooseUserImageButtonPressed()
            }
            .addDisposableTo(presenterBindDisposeBag)
        
        createAccountButton.rx.tap
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                
                strongSelf.presenter?.createButtonPressed()
            }
            .addDisposableTo(presenterBindDisposeBag)
    }
}
