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
    
    private(set) var isLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLoaded = true
    }
    
    func showOKAlertWith(title: String?, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: R.string.localizable.alertOk(), style: .default, handler: nil))
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
    
    
    //SCROLL VIEW
    private(set) var scrollView: TPKeyboardAvoidingScrollView?
    @discardableResult func addScrollView(layoutBlock: ((LayoutProxy, LayoutProxy) -> Void)? = nil) -> UIScrollView{
        self.scrollView?.removeFromSuperview()
        
        let scrollView = TPKeyboardAvoidingScrollView()
        
        view.addSubview(scrollView)
        
        scrollView.keyboardDismissMode = .interactive
        scrollView.alwaysBounceVertical = true
        
        if let layoutBlock = layoutBlock{
            constrain(view, scrollView, block: layoutBlock)
        }else{
            constrain(view, scrollView) { (view, scrollView) in
                scrollView.top == view.top
                scrollView.left == view.left
                scrollView.bottom == view.bottom
                scrollView.right == view.right
            }
        }
        
        self.scrollView = scrollView
        
        return scrollView
    }
    
    func addScrollView(withSubView subView: UIView, scrollViewLayoutBlock: ((LayoutProxy, LayoutProxy) -> Void)? = nil, subViewLayoutBlock: ((LayoutProxy, LayoutProxy) -> Void)? = nil){
        let scrollView = addScrollView(layoutBlock: scrollViewLayoutBlock)
        
        scrollView.addSubview(subView)
        
        if let subViewLayoutBlock = subViewLayoutBlock{
            constrain(subView, scrollView, block: subViewLayoutBlock)
        }else{
            constrain(subView, scrollView) { (subView, scrollView) in
                subView.edges == scrollView.edges
                
                subView.width == scrollView.width
            }
        }
    }
    
    //BACKGROUND VIEW
    private(set) var backgroundImageView: UIImageView?
    func addBackgroundImageView(withImage image: UIImage){
        self.backgroundImageView?.removeFromSuperview()
        
        let backgroundImageView = UIImageView(image: image)
        
        view.addSubview(backgroundImageView)
        
        constrain(view, backgroundImageView) { (view, backgroundImageView) in
            backgroundImageView.edges == view.edges
        }
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
