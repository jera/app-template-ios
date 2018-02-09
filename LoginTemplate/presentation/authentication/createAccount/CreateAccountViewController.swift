//
//  CreateAccountViewController.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 22/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

class CreateAccountViewController: BaseScrollViewController {
    
    var presenter: CreateAccountPresenterProtocol!
    
    private lazy var createAccountView: CreateAccountView = {
        return CreateAccountView.loadNibName(viewModel: presenter)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.createAccountTitle()
        view.backgroundColor = .white
    
        addChildViewToScrollView(childView: createAccountView)
        addCloseButton(image: UIImage(named: "ic_nav_back")!) { [weak self] () in
            self?.presenter?.closeButtonTapped()
        }
    }
}
