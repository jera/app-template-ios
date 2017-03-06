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
import Material

class ForgotPasswordView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var confirmButton: RaisedButton!
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyLayout()
        applyTexts()
    }
    
    private func applyLayout() {
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        
        emailTextField.applyAppearance(appearance: .white)
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        
        confirmButton.applyAppearance(appearance: .main)
        confirmButton.layer.cornerRadius = 5
    }
    
    private func applyTexts(){
        titleLabel.text = R.string.localizable.forgotPasswordTitle()
        emailTextField.placeholder = R.string.localizable.defaultEmail()
        confirmButton.setTitleWithoutAnimation(R.string.localizable.forgotPasswordSend().uppercased(), for: .normal)
    }
    
    static func loadNibName() -> ForgotPasswordView {
        return Bundle.main.loadNibNamed("ForgotPasswordView", owner: nil, options: nil)!.first as! ForgotPasswordView
    }

}
