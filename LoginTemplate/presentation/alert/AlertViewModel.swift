//
//  AlertViewModel.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 09/02/18.
//  Copyright © 2018 Jera. All rights reserved.
//

import UIKit

struct AlertViewModel {
    
    var title: String?
    var message: String?
    var alertActions: [AlertActionViewModel]
    
    init(title: String? = nil, message: String? = nil, actions: [AlertActionViewModel]) {
        self.title = title
        self.message = message
        self.alertActions = actions
    }
}

struct AlertActionViewModel {
    
    var title: String
    var actionType: UIAlertActionStyle
    var action: (() -> ())?
    
    init(title: String, actionType: UIAlertActionStyle = .`default`, action: (() -> ())? = nil) {
        self.title = title
        self.actionType = actionType
        self.action = action
    }
    
    func transform() -> UIAlertAction {
        return UIAlertAction(title: title, style: actionType, handler: { (_) in
            if let action = self.action {
                action()
            }
        })
    }
}
