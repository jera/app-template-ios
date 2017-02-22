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
    fileprivate var textLabel: String = "Informe o seu email para recuperar sua senha"
    fileprivate var placeholderTextField: String = "Email"
    fileprivate var titleButton: String = "ENVIAR"
    fileprivate var emailErrorTextField: String?
}

class ForgotPasswordView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: BaseTextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    private(set) var viewModel: ForgotPasswordViewModel?
    let disposeBag = DisposeBag()
    
    var enterButtonTapped: ControlEvent<Void>{
        return confirmButton.rx.tap
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyLayout()
        
        viewModel = ForgotPasswordViewModel()
        
        bindViewModel()
    }
    
    private func applyLayout() {
        titleLabel.textColor = UIColor.defaultTitleLabel()
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        
        emailTextField.applyAppearence(textFieldAppearence: .Default)
        
        emailErrorLabel.textColor = UIColor.red
        emailErrorLabel.font = UIFont.systemFont(ofSize: 10)
        
        confirmButton.backgroundColor = UIColor.defaultBackgroundButton()
        confirmButton.setTitleColor(UIColor.defaultTitleButton(), for: .normal)
        confirmButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        confirmButton.layer.cornerRadius = 5
    }
    
    func bindViewModel(){
        guard let viewModel = viewModel else { return }
        
        self.viewModel = viewModel
        self.titleLabel.text = viewModel.textLabel
        self.emailTextField.placeholder = viewModel.placeholderTextField
        self.emailErrorLabel.text = viewModel.emailErrorTextField
        
        confirmButton.setTitle(viewModel.titleButton, for: .normal, animated: false)
    }
    
    static func loadNibName() -> ForgotPasswordView {
        return Bundle.main.loadNibNamed("ForgotPasswordView", owner: nil, options: nil)!.first as! ForgotPasswordView
    }

}
