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

class CreateAccountViewController: BaseViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: TextField!
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var phoneTextField: TextField!
    @IBOutlet weak var cpfTextField: TextField!
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
        avatarImageView.image = UIImage(named: "avatar")
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderColor = UIColor(white: 190/255, alpha: 1).cgColor
        avatarImageView.layer.borderWidth = 2.0
        
        nameTextField.applyAppearance(appearance: .white)
        
        emailTextField.applyAppearance(appearance: .white)
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        
        phoneTextField.applyAppearance(appearance: .white)
        phoneTextField.keyboardType = .numberPad
        
        cpfTextField.applyAppearance(appearance: .white)
        cpfTextField.keyboardType = .numberPad
        
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
        emailTextField.placeholder = R.string.localizable.createAccountEmail()
        phoneTextField.placeholder = R.string.localizable.createAccountPhone()
        cpfTextField.placeholder = R.string.localizable.createAccountCpf()
        passwordTextField.placeholder = R.string.localizable.createAccountPassword()
        confirmPasswordTextField.placeholder = R.string.localizable.createAccountConfirmPassword()
        
        changePhotoButton.setTitleWithoutAnimation(R.string.localizable.createAccountSeachPhoto(), for: .normal)
        createAccountButton.setTitleWithoutAnimation(R.string.localizable.createAccountFinishRegister(), for: .normal)
    }
    
    private func bind(){
        
    }
}
