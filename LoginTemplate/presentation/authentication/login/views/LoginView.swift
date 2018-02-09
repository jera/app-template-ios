//
//  LoginView.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 08/02/18.
//  Copyright © 2018 Jera. All rights reserved.
//

import UIKit
import Material
import RxSwift
import RxGesture

protocol LoginViewModelProtocol {
    var email: Variable<String> {get}
    var password: Variable<String> {get}
    
    var emailErrorString: Observable<String?> {get}
    var passwordErrorString: Observable<String?> {get}
    
    var loginButtonEnabled: Observable<Bool> {get}
    
    var loginRequestResponse: Observable<RequestResponse<User>> { get }
    var facebookRequestResponse: Observable<RequestResponse<User>> { get }
    var googleRequestResponse: Observable<RequestResponse<User>> { get }
    
    func loginButtonTapped()
    func createAccountButtonTapped()
    func forgotPasswordButtonTapped()
    func facebookLoginButtonTapped()
    func googleLoginButtonTapped()
}

class LoginView: UIView {
    
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
    private var viewModel: LoginViewModelProtocol? {
        didSet { bind() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyLayout()
        applyTexts()
    }
    
    private func applyLayout() {
        backgroundColor = .clear
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
        disposeBag = DisposeBag()

        guard let viewModel = viewModel else { return }

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
        
        viewModel.loginButtonEnabled
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.loginRequestResponse
            .subscribe(onNext: { [weak self] (requestResponse) in
                guard let _ = self else { return }
                
//                switch requestResponse { //TODO Arrumar
//                case .new:
//                    strongSelf.hideHud()
//                case .loading:
//                    strongSelf.showHudWith(title: R.string.localizable.loginLoging())
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
        
        viewModel.facebookRequestResponse
            .subscribe(onNext: { [weak self] (requestResponse) in
                guard let _ = self else { return }
                
//                switch requestResponse {
//                case .new:
//                    strongSelf.hideHud()
//                case .loading:
//                    strongSelf.showHudWith(title: R.string.localizable.loginLogingWithFacebook())
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
        
        viewModel.googleRequestResponse
            .subscribe(onNext: { [weak self] (requestResponse) in
                guard let _ = self else { return }
                
//                switch requestResponse {
//                case .new:
//                    strongSelf.hideHud()
//                case .loading:
//                    strongSelf.showHudWith(title: R.string.localizable.loginLogingWithGoogle())
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
        
        //Buttons Action
        loginButton.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                strongSelf.viewModel?.loginButtonTapped()
            }
            .disposed(by: disposeBag)
        
        facebookButton.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                strongSelf.viewModel?.facebookLoginButtonTapped()
            }
            .disposed(by: disposeBag)
        
        googleButton.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                strongSelf.viewModel?.googleLoginButtonTapped()
            }
            .disposed(by: disposeBag)
        
        forgotPasswordButton.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                strongSelf.viewModel?.forgotPasswordButtonTapped()
            }
            .disposed(by: disposeBag)
        
        createAccountButton.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                strongSelf.viewModel?.createAccountButtonTapped()
            }
            .disposed(by: disposeBag)
    }
}

extension LoginView {
    
    static func loadNibName(viewModel: LoginViewModelProtocol) -> LoginView {
        let view = R.nib.loginView.firstView(owner: nil)!
        view.viewModel = viewModel
        return view
    }
}
