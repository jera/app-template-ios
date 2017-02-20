//
//  BaseViewController.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit
import RxCocoa
import SVProgressHUD
import Cartography

protocol BaseViewInterface: class {
    
}

class BaseViewController: UIViewController{
    private(set) var isLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLoaded = true
    }
    
    func showOKAlertWith(title: String?, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    //HUD VIEW
    private var loadingHUDView: LoadingHUDView?
    
    func showHudWith(title: String){
        hideHud()
        
        let loadingHUDView = LoadingHUDView.loadFromNib(title: title)
        view.addSubview(loadingHUDView)
        constrain(view, loadingHUDView) { (view, loadingHUDView) in
            loadingHUDView.edges == view.edges
        }
        
        self.loadingHUDView = loadingHUDView
    }
    
    func hideHud(){
        loadingHUDView?.removeFromSuperview()
    }
    
//    static func customizeProgressHUD(){
//        SVProgressHUD.setDefaultMaskType(.black)
//    }
    
    deinit {
        print("dealloc ---> \(String(describing: type(of: self)))")
    }
}
