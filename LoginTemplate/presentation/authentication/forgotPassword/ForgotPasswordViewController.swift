//
//  ForgotPasswordViewController.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseScrollViewController {
    
    var presenter: ForgotPasswordPresenterProtocol!
    
    private lazy var forgotPasswordView: ForgotPasswordView = {
        return ForgotPasswordView.loadNibName(viewModel: presenter)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.forgotPasswordTitleNavBar()
        view.backgroundColor = .white
        
        addChildViewToScrollView(childView: forgotPasswordView)
        addCloseButton(image: UIImage(named: "ic_nav_back")!) { [weak self] () in
            self?.presenter?.didTapCloseForgotPasswordView()
        }
    }
}
