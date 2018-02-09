//
//  LoadingHUDView.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 20/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

class LoadingHUDView: UIView {
    
    static func loadFromNib(title: String? = nil) -> LoadingHUDView {
        let loadingHUDView = Bundle.main.loadNibNamed("LoadingHUDView", owner: nil, options: nil)!.first! as! LoadingHUDView
        
        if let title = title {
            loadingHUDView.titleLabel.text = title
        }
        
        return loadingHUDView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loadingContainerView.layer.cornerRadius = 15
        activityIndicatorView.startAnimating()
    }

    @IBOutlet private weak var loadingContainerView: UIView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var titleLabel: UILabel!
}
