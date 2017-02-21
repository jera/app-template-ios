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
    
    func showHudWith(title: String){
        SVProgressHUD.show(withStatus: title)
    }
    
    func hideHud(){
        SVProgressHUD.dismiss()
    }
    
    static func customizeProgressHUD(){
        SVProgressHUD.setDefaultMaskType(.black)
    }
    
    public func addCloseButton(image: UIImage, block: @escaping () -> Void ) {
        let closeBarButton = UIBarButtonItem(image: image, style: .done, target: nil, action: nil)
        _ = closeBarButton.rx.tap
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { (_) in
                block()
            })
        navigationItem.leftBarButtonItem = closeBarButton
    }
    
    deinit {
        print("dealloc ---> \(String(describing: type(of: self)))")
    }
}
