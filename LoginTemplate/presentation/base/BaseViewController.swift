//
//  BaseViewController.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit
import RxCocoa
import Cartography

protocol BaseViewProtocol: class {
    
}

class BaseViewController: UIViewController {
    
    private var loadingHUDView: LoadingHUDView?
    private var backgroundImageView: UIImageView?
    private(set) var isLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoaded = true
    }
    
    func showOKAlertWith(title: String?, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: R.string.localizable.alertOk(), style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func showHudWith(title: String) {
        hideHud()
        
        let loadingHUDView = LoadingHUDView.loadFromNib(title: title)
        view.addSubview(loadingHUDView)
        constrain(view, loadingHUDView) { (view, loadingHUDView) in
            loadingHUDView.edges == view.edges
        }
        
        self.loadingHUDView = loadingHUDView
    }
    
    func hideHud() {
        loadingHUDView?.removeFromSuperview()
    }
    
    func addBackgroundImage(_ image: UIImage) {
        backgroundImageView?.removeFromSuperview()
        backgroundImageView = UIImageView(image: image)
        backgroundImageView?.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView!)
        view.sendSubview(toBack: backgroundImageView!)
        constrain(view, backgroundImageView!) { (container, image) in
            image.edges == container.edges
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        print("dealloc ---> \(String(describing: type(of: self)))")
    }
}
