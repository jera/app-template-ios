//
//  BaseWireFrame.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

protocol PresentedWireFrameProtocol {
    
}

protocol PresenterWireFrameProtocol: class {
    func  wireframeDidDismiss()
}

class BaseWireFrame: NSObject {
    var presentedWireFrame: PresentedWireFrameProtocol?
    weak var presenterWireFrame: PresenterWireFrameProtocol?
    
    deinit {
        print("dealloc ---> \(String(describing: type(of: self)))")
    }
}

extension BaseWireFrame: PresenterWireFrameProtocol {
    func wireframeDidDismiss() {
        presentedWireFrame = nil
    }
}

extension BaseWireFrame: PresentedWireFrameProtocol {
    
}
