//
//  ForgotPasswordView.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 09/02/18.
//  Copyright © 2018 Jera. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture
import Material

protocol ForgotPasswordViewModelProtocol {
    var email: Variable<String> {get}
    var emailErrorString: Observable<String?> {get}
    var forgotPasswordButtonEnabled: Observable<Bool> {get}
    var forgotPasswordRequestResponse: Observable<RequestResponse<String?>> { get }
    
    func forgotPasswordButtonTapped()
}

class ForgotPasswordView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var confirmButton: RaisedButton!
    
    private var disposeBag: DisposeBag!
    private var viewModel: ForgotPasswordViewModelProtocol? {
        didSet { bind() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyAppearance()
    }
    
    private func applyAppearance() {
        backgroundColor = .clear
        
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.text = R.string.localizable.forgotPasswordTitle()
        
        emailTextField.applyAppearance(appearance: .white)
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        emailTextField.placeholder = R.string.localizable.defaultEmail()
        
        confirmButton.applyAppearance(appearance: .main)
        confirmButton.layer.cornerRadius = 5
        confirmButton.setTitleWithoutAnimation(R.string.localizable.forgotPasswordSend().uppercased(), for: .normal)
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
        
        viewModel.forgotPasswordButtonEnabled
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.forgotPasswordRequestResponse
            .subscribe(onNext: { [weak self] (requestResponse) in
                guard let _ = self else { return }
                
//                switch requestResponse { //TODO Arrumar
//                case .new:
//                    strongSelf.hideHud()
//                case .loading:
//                    strongSelf.showHudWith(title: R.string.localizable.alertLoading())
//                case .failure(let error):
//                    strongSelf.hideHud()
//                    strongSelf.showOKAlertWith(title: R.string.localizable.alertTitle(), message: error.localizedDescription)
//                case .success(let message):
//                    strongSelf.hideHud()
//                    strongSelf.showOKAlertWith(title: R.string.localizable.forgotPasswordCheckYourEmail(), message: message ?? R.string.localizable.forgotPasswordMessage())
//                case .cancelled:
//                    strongSelf.hideHud()
//                }
            })
            .disposed(by: disposeBag)

        confirmButton.rx
            .tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_) in
                guard let strongSelf = self else { return }
                strongSelf.viewModel?.forgotPasswordButtonTapped()
            }
            .disposed(by: disposeBag)
    }
    
}

extension ForgotPasswordView {
    
    static func loadNibName(viewModel: ForgotPasswordViewModelProtocol) -> ForgotPasswordView {
        let view = R.nib.forgotPasswordView.firstView(owner: nil)!
        view.viewModel = viewModel
        return view
    }
}
