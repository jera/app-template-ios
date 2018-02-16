//
//  PlaceholderViewModel.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 09/02/18.
//  Copyright © 2018 Jera. All rights reserved.
//

import UIKit

enum PlaceholderType {
    case loading
    case error
}

struct PlaceholderViewModel {
    
    var text: String?
    var action: (() -> ())?
    var cancelAction: (() -> ())?
    
    init(text: String? = nil, action: (() -> ())? = nil, cancelAction: (() -> ())? = nil) {
        self.text = text
        self.action = action
        self.cancelAction = cancelAction
    }
}
