//
//  MaskTextFieldFormView.swift
//  Yoseph
//
//  Created by Alessandro Nakamuta on 20/06/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit
import Material

class MaskTextFieldFormView: UIView {
    
    @IBOutlet weak var textField: MaskTextField!
    
    class func instantiateFromNib() -> MaskTextFieldFormView {
        return R.nib.maskTextFieldFormView.firstView(owner: nil)!
    }
    
    func applyAppearance(appearance: TextFieldAppearence) {
        textField.applyAppearance(appearance: appearance)
    }
    
}
