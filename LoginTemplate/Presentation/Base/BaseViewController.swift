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
import TPKeyboardAvoiding

protocol BaseViewInterface: class {
    
}

class BaseViewController: UIViewController{
    
    lazy var scrollView: TPKeyboardAvoidingScrollView = self.initializeScrollView()
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
    
    //MARK: ScrollView
    
    func initializeScrollView() -> TPKeyboardAvoidingScrollView{
        let scrollView = TPKeyboardAvoidingScrollView()
        
        scrollView.backgroundColor = UIColor.clear
        scrollView.keyboardDismissMode = .interactive
        scrollView.alwaysBounceVertical = true
        
        view.addSubview(scrollView)
        constrain(scrollView, view, block: { (scrollView, containerView) in
            scrollView.edges == containerView.edges
        })
        return scrollView
    }
    
    func addScrollView(withSubview subview: UIView){
        automaticallyAdjustsScrollViewInsets = false
        scrollView.addSubview(subview)
        
        constrain(scrollView, subview) { (scrollView, subview) in
            subview.edges == scrollView.edges
            subview.width == scrollView.width
        }
    }
    
    deinit {
        print("dealloc ---> \(String(describing: type(of: self)))")
    }
}
