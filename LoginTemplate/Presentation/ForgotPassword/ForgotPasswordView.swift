//
//  ForgotPasswordView.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ForgotPasswordViewModel {
    fileprivate var textLabel: String?
    fileprivate var placeholderTextField: String?
    fileprivate var titleButton: String?

    
    init() {
        
        bind()
    }
    
    private func bind(){
        textLabel = "Informe o seu email para recuperar sua senha"
        placeholderTextField = "Email"
        titleButton = "ENVIAR"
    }
}

class ForgotPasswordView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: BaseTextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    private(set) var viewModel: ForgotPasswordViewModel?
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyLayout()
    }
    
    private func applyLayout() {
        //titleLabel.textColor = UIColor.titleCreateAccount()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        
        emailTextField.applyAppearence(textFieldAppearence: .Black)
        emailTextField.detailLabel.font = UIFont.systemFont(ofSize: 10)
        //emailTextField.detailColor = UIColor.red
        
        //confirmButton.backgroundColor = UIColor.createAccountButton()
        //confirmButton.setTitleColor(UIColor.createAccountLabelButton(), for: .normal)
        confirmButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        confirmButton.layer.cornerRadius = 5
    }
    
    func bindViewModel(viewModel: ForgotPasswordViewModel?){
        guard let viewModel = viewModel else { return }
        
        self.viewModel = viewModel
        self.titleLabel.text = viewModel.textLabel
        self.emailTextField.placeholder = viewModel.placeholderTextField
        
        confirmButton.setTitle(viewModel.titleButton, for: .normal, animated: false)
        
    }
    
    static func loadNibName() -> ForgotPasswordView {
        return Bundle.main.loadNibNamed("ForgotPasswordView", owner: nil, options: nil)!.first as! ForgotPasswordView
    }

}
