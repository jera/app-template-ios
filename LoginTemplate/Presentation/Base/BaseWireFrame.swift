//
//  BaseWireFrame.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

protocol PresentedWireFrameInterface {
    
}

protocol PresenterWireFrameInterface: class {
    func  wireframeDidDismiss()
}

class BaseWireFrame: NSObject {
    var presentedWireFrame: PresentedWireFrameInterface?
    weak var presenterWireFrame: PresenterWireFrameInterface?
    
    deinit {
        print("dealloc ---> \(String(describing: type(of: self)))")
    }
}

extension BaseWireFrame: PresenterWireFrameInterface {
    func wireframeDidDismiss() {
        presentedWireFrame = nil
    }
}

extension BaseWireFrame: PresentedWireFrameInterface {
    
}
