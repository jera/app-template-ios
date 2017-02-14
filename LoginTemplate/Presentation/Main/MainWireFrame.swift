//
//  MainWireFrame.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum MainPage {
    case Login
    case Dashboard
}

class MainWireFrame: BaseWireFrame {
    
    private let disposeBag = DisposeBag()
    //var establishmentWireFrame: EstablishmentWireFrame?
    var loginWireFrame: LoginWireFrame?
    
    var window: UIWindow!
    
   /* override init() {
        super.init()
        
        NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: kNotificationAuthExpired))
            .subscribe(onNext: { [weak self] (_) in
                guard let strongSelf = self else { return }
                
                if OAuth2Session.currentSession == nil{
                    Helper.showAlert(message: "Sessão expirou. Por favor, faça login novamente")
                    
                    strongSelf.goToPage(mainPage: .Login)
                }
                
            }).addDisposableTo(disposeBag)
    }*/
    
    private(set) var mainPage:MainPage?{
        didSet{
            if let mainPage = mainPage{
                if oldValue != mainPage{
                    switch mainPage{
                    case .Login:
                        
                        loginWireFrame = LoginWireFrame()
                        self.window.rootViewController = loginWireFrame!.presentLoginInterface(mainWireFrame: self)
                        
                    case .Dashboard:
                        
                        loginWireFrame = nil
                        
                    }
                }
            }
        }
    }
    
    @discardableResult func goToPage(mainPage: MainPage, refresh: Bool = false) -> Bool {
        if refresh{
            self.mainPage = mainPage
            return true
        }
        
        if self.mainPage != mainPage {
            self.mainPage = mainPage
            return true
        }
        return false
    }
    
}
