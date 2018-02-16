//
//  LoadingView.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 09/02/18.
//  Copyright © 2018 Jera. All rights reserved.
//

import UIKit
import Cartography

class LoadingView: UIView {
    
    private let loadingConstraintGroup = ConstraintGroup()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 20)
        textLabel.textColor = .white
        textLabel.numberOfLines = 0
        return textLabel
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
        self.addSubview(activityIndicatorView)
        
        constrain(self, activityIndicatorView, replace: loadingConstraintGroup) { (view, indicator) in
            indicator.center == view.center
        }
    }
    
    private func addTextLabel() {
        self.addSubview(textLabel)
        
        constrain(self, activityIndicatorView, textLabel) { (view, indicator, label) in
            label.top == indicator.bottom + 16
            label.centerX == view.centerX
        }
    }
}

extension LoadingView {
    
    func presentOn(parentView: UIView, with viewModel: PlaceholderViewModel) {
        if let text = viewModel.text {
            addTextLabel()
            textLabel.text = text
        } else {
            textLabel.removeFromSuperview()
        }
        
        parentView.addSubview(self)
        constrain(parentView, self) { (container, loading) in
            loading.edges == container.edges
        }
        
        self.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
    }
}
