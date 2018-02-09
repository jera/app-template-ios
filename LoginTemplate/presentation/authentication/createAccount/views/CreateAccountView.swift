//
//  CreateAccountView.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 09/02/18.
//  Copyright © 2018 Jera. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture
import Material

protocol CreateAccountViewModelProtocol {
    var userImage: Observable<UIImage?> {get}
    
    var name: Variable<String> {get}
    var nameErrorString: Observable<String?> {get}
    
    var email: Variable<String> {get}
    var emailErrorString: Observable<String?> {get}
    
    var phone: Variable<String> {get}
    var phoneErrorString: Observable<String?> {get}
    
    var cpf: Variable<String> {get}
    var cpfErrorString: Observable<String?> {get}
    
    var password: Variable<String> {get}
    var passwordErrorString: Observable<String?> {get}
    
    var passwordConfirm: Variable<String> {get}
    var passwordConfirmErrorString: Observable<String?> {get}
    
    var createAccountButtonEnabled: Observable<Bool> {get}
    
    var createAccountRequestResponse: Observable<RequestResponse<User>> { get }
    
    func createButtonTapped()
    func chooseUserImageButtonTapped()
}

class CreateAccountView: UIView {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: TextField!
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var phoneTextField: MaskTextField!
    @IBOutlet weak var cpfTextField: MaskTextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var confirmPasswordTextField: TextField!
    
    @IBOutlet weak var changePhotoButton: FlatButton!
    @IBOutlet weak var createAccountButton: RaisedButton!
    
    private var disposeBag: DisposeBag!
    private var viewModel: CreateAccountViewModelProtocol? {
        didSet { bind() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyAppearance()
        applyTexts()
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
        disposeBag = DisposeBag()
        
        guard let viewModel = viewModel else { return }
        
        viewModel.userImage
            .map { (userImage) -> UIImage in
                return userImage ?? #imageLiteral(resourceName: "avatar")
            }
            .bind(to: avatarImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.name
            .asObservable()
            .bind(to: nameTextField.rx.text)
            .disposed(by: disposeBag)
        
        nameTextField.rx.text
            .asObservable()
            .map { (text) -> String in
                return text ?? ""
            }
            .bind(to: viewModel.name)
            .disposed(by: disposeBag)
        
        viewModel.nameErrorString
            .subscribe(onNext: { [weak self] (errorString) in
                self?.nameTextField.detail = errorString
            })
            .disposed(by: disposeBag)
        
        viewModel.email
            .asObservable()
            .bind(to: emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text
            .asObservable()
            .map { (text) -> String in
                return text ?? ""
            }
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        viewModel.emailErrorString
            .subscribe(onNext: { [weak self] (errorString) in
                self?.emailTextField.detail = errorString
            })
            .disposed(by: disposeBag)
        
        viewModel.phone
            .asObservable()
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        phoneTextField.rawTextObservable
            .bind(to: viewModel.phone)
            .disposed(by: disposeBag)
        
        viewModel.phoneErrorString
            .subscribe(onNext: { [weak self] (errorString) in
                self?.phoneTextField.detail = errorString
            })
            .disposed(by: disposeBag)
        
        viewModel.cpf
            .asObservable()
            .bind(to: cpfTextField.rx.text)
            .disposed(by: disposeBag)
        
        cpfTextField.rawTextObservable
            .bind(to: viewModel.cpf)
            .disposed(by: disposeBag)
        
        viewModel.cpfErrorString
            .subscribe(onNext: { [weak self] (errorString) in
                self?.cpfTextField.detail = errorString
            })
            .disposed(by: disposeBag)
        
        viewModel.password
            .asObservable()
            .bind(to: passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .asObservable()
            .map { (text) -> String in
                return text ?? ""
            }
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        viewModel.passwordErrorString
            .subscribe(onNext: { [weak self] (errorString) in
                self?.passwordTextField.detail = errorString
            })
            .disposed(by: disposeBag)
        
        viewModel.passwordConfirm
            .asObservable()
            .bind(to: confirmPasswordTextField.rx.text)
            .disposed(by: disposeBag)
        
        confirmPasswordTextField.rx.text
            .asObservable()
            .map { (text) -> String in
                return text ?? ""
            }
            .bind(to: viewModel.passwordConfirm)
            .disposed(by: disposeBag)
        
        viewModel.passwordConfirmErrorString
            .subscribe(onNext: { [weak self] (errorString) in
                self?.confirmPasswordTextField.detail = errorString
            })
            .disposed(by: disposeBag)
        
        viewModel.createAccountButtonEnabled
            .bind(to: createAccountButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.createAccountRequestResponse
            .subscribe(onNext: { [weak self] (requestResponse) in
                guard let _ = self else { return }
                
//                switch requestResponse {
//                case .new:
//                    strongSelf.hideHud()
//                case .loading:
//                    strongSelf.showHudWith(title: R.string.localizable.alertWait())
//                case .failure(let error):
//                    strongSelf.hideHud()
//                    strongSelf.showOKAlertWith(title: R.string.localizable.alertTitle(), message: error.localizedDescription)
//                case .success:
//                    strongSelf.hideHud()
//                case .cancelled:
//                    strongSelf.hideHud()
//                }
            })
            .disposed(by: disposeBag)
        
        changePhotoButton.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                strongSelf.viewModel?.chooseUserImageButtonTapped()
            }
            .disposed(by: disposeBag)
        
        createAccountButton.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                strongSelf.viewModel?.createButtonTapped()
            }
            .disposed(by: disposeBag)
    }
}

extension CreateAccountView {
    
    static func loadNibName(viewModel: CreateAccountViewModelProtocol) -> CreateAccountView {
        let view = R.nib.createAccountView.firstView(owner: nil)!
        view.viewModel = viewModel
        return view
    }
}
