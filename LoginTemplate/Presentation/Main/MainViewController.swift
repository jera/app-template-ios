//
//  MainViewController.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 16/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit
import Cartography
import RxSwift

class MainViewController: BaseViewController {
    
    private var disposeBag: DisposeBag!
    var presenter: MainPresenterProtocol? {
        didSet {
            bind()
        }
    }
    
    private func bind() {
        disposeBag = DisposeBag()
        
        if let presenter = presenter {
            presenter.authExpiredMessage.subscribe(onNext: { (authExpiredMessage) in
                print("TODO: Toast auth expired message")
            }).addDisposableTo(disposeBag)
        }
        
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
    }
    
    private(set) var currentViewController: UIViewController? {
        didSet {
            if let currentViewController = currentViewController {
                currentViewController.willMove(toParentViewController: self)
                addChildViewController(currentViewController)
                currentViewController.didMove(toParentViewController: self)
                
                if let oldViewController = oldValue {
                    view.insertSubview(currentViewController.view, belowSubview: oldViewController.view)
                } else {
                    view.addSubview(currentViewController.view)
                }
                
                constrain(currentViewController.view, view, block: { (childView, parentView) in
                    childView.edges == parentView.edges
                })
                
                self.setNeedsStatusBarAppearanceUpdate()
            }
            
            if let oldViewController = oldValue {
                self.applyScreenTransition(newViewController: currentViewController, oldViewController: oldViewController)
            }
        }
    }
    
    private func applyScreenTransition(newViewController: UIViewController?, oldViewController: UIViewController) {
        if let newViewController = newViewController {
            newViewController.view.transform = CGAffineTransform(translationX: 0, y: -(self.view.frame.size.height))
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [], animations: {
                newViewController.view.transform = CGAffineTransform.identity
                oldViewController.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
                
            }, completion: { (finished) in
                oldViewController.removeDefinitely()
            })
            
        } else {
            oldViewController.removeDefinitely()
        }
    }
    
    func setCurrentViewController(viewController: UIViewController) {
        currentViewController = viewController
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let currentViewController = currentViewController else {
            return .default
        }
        
        return currentViewController.preferredStatusBarStyle
    }
}
extension UIViewController {
    
    func removeDefinitely() {
        self.dismiss(animated: false, completion: nil)
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
}
