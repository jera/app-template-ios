//
//  BaseScrollViewController.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 08/02/18.
//  Copyright © 2018 Jera. All rights reserved.
//

import UIKit
import Cartography
import TPKeyboardAvoiding

class BaseScrollViewController: BaseViewController {
    
    internal var scrollViewConstraintGroup = ConstraintGroup()
    
    internal let scrollView: TPKeyboardAvoidingScrollView = {
        let view = TPKeyboardAvoidingScrollView()
        view.alwaysBounceVertical = false
        return view
    }()
    
    private var childView: UIView?
    
    override func loadView() {
        super.loadView()
        addScrollView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func addScrollView() {
        view.addSubview(scrollView)
        updateScrollViewConstraints()
    }
    
    internal func updateScrollViewConstraints(topMargin: CGFloat = 0, bottomMargin: CGFloat = 0, ignoreSafeArea: Bool = false) {
        
        constrain(view, scrollView, car_topLayoutGuide, car_bottomLayoutGuide, replace: scrollViewConstraintGroup) { (view, scroll, topGuide, bottomGuide) in
            scroll.left == view.left
            scroll.right == view.right
            
            if ignoreSafeArea {
                scroll.top == view.top + topMargin
                scroll.bottom == view.bottom - bottomMargin
                
            } else if #available(iOS 11.0, *) {
                scroll.top == view.safeAreaLayoutGuide.top + topMargin
                scroll.bottom == view.safeAreaLayoutGuide.bottom - bottomMargin
                
            } else {
                scroll.top == topGuide.bottom + topMargin
                scroll.bottom == bottomGuide.top - bottomMargin
            }
        }
    }
    
    internal func addChildViewToScrollView(childView: UIView, constraintBlock: ((ViewProxy, ViewProxy) -> Void)? = nil) {
        scrollView.addSubview(childView)
        
        self.childView?.removeFromSuperview()
        self.childView = childView
        
        if let constraintBlock = constraintBlock {
            constrain(scrollView, childView, block: constraintBlock)
            
        } else {
            constrain(scrollView, childView) { (scroll, subView) in
                subView.edges == scroll.edges
                subView.width == scroll.width
            }
        }
    }
}
