//
//  ErrorView.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 09/02/18.
//  Copyright © 2018 Jera. All rights reserved.
//


import UIKit
import Material
import Cartography

class ErrorView: UIView {
    
    private let errorViewConstraintGroup = ConstraintGroup()
    private var actionBlock: (() -> ())?
    private var cancelBlock: (() -> ())?
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 20)
        textLabel.textColor = .white
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        return textLabel
    }()
    
    private lazy var tryAgainButton: RaisedButton = {
        let button = RaisedButton()
        button.applyAppearance(appearance: .main)
        button.setTitle(R.string.localizable.defaultTryAgain().uppercased(), for: .normal)
        return button
    }()
    
    private lazy var cancelButton: FlatButton = {
        let button = FlatButton()
        button.setTitle(R.string.localizable.defaultCancel().uppercased(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        createScreen()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func createScreen() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.85)
        self.addSubview(textLabel)
        
        constrain(self, textLabel, replace: errorViewConstraintGroup) { (view, label) in
            label.center == view.center
            label.right >= view.right - 30
            label.left >= view.left + 30
        }
    }
    
    private func addTryAgainButton() {
        self.addSubview(tryAgainButton)
        self.addSubview(cancelButton)
        
        _ = tryAgainButton.rx.tap
            .asObservable()
            .takeUntil(rx.deallocated)
            .bind {[weak self] in
                guard let strongSelf = self else { return }
                if let action = strongSelf.actionBlock {
                    action()
                }
        }
        
        _ = cancelButton.rx.tap
            .asObservable()
            .takeUntil(rx.deallocated)
            .bind {[weak self] in
                guard let strongSelf = self else { return }
                if let cancel = strongSelf.cancelBlock {
                    cancel()
                }
                strongSelf.dismiss()
        }
        
        constrain(self, textLabel, tryAgainButton, cancelButton) { (view, label, button, cancel) in
            button.top == label.bottom + 16
            button.left == view.left + 30
            button.right == view.right - 30
            button.height == 44
            
            cancel.height == 30
            cancel.top == button.bottom + 8
            cancel.left == view.left + 30
            cancel.right == view.right - 30
        }
    }
    
    private func makeDismissAnimation() {
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 3, animations: {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.alpha = 0
            
            }, completion: {[weak self] (finished) in
                guard let strongSelf = self else { return }
                strongSelf.removeFromSuperview()
        })
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.alpha = 0
            
            }, completion: {[weak self] (finished) in
                guard let strongSelf = self else { return }
                strongSelf.removeFromSuperview()
        })
    }
}

extension ErrorView {
    
    func presentOn(parentView: UIView, with viewModel: PlaceholderViewModel) {
        textLabel.text = viewModel.text
        actionBlock = viewModel.action
        cancelBlock = viewModel.cancelAction
        
        let shouldAddButton = viewModel.action != nil
        
        if shouldAddButton {
            addTryAgainButton()
        }
        
        parentView.addSubview(self)
        constrain(parentView, self) { (container, loading) in
            loading.edges == container.edges
        }
        
        self.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.alpha = 1
            
            }, completion: {[weak self] (finished) in
                guard let strongSelf = self else { return }
                
                if !shouldAddButton && finished {
                    strongSelf.makeDismissAnimation()
                }
        })
    }
}

