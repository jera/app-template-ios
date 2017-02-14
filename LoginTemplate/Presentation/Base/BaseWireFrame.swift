//
//  BaseWireFrame.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit
import ObjectiveC

class BaseWireFrame: NSObject {
    
    func storyBoard(with name: String) -> UIStoryboard {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        return storyboard
    }
    
    func navigationControllerFromStoryboard(stroryBoardName: String) -> BaseNavigationController {
        let storyboard = self.storyBoard(with: stroryBoardName)
        let navigationController = storyboard.instantiateInitialViewController() as! BaseNavigationController
        return navigationController
    }
    
    func deallocDependences(){
        
    }
    
    func setMessageToShowOnViewController(messageToShow: String?){
        //do nothing
    }
    
    deinit {
        print("dealloc ---> \(String(describing: type(of: self)))")
    }
}
