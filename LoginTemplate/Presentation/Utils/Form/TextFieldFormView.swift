//
//  TextFieldFormView.swift
//  Yoseph
//
//  Created by Alessandro Nakamuta on 20/06/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit
import Material

class TextFieldFormView: UIView {

    @IBOutlet weak var textField: TextField!
    
    class func instantiateFromNib() -> TextFieldFormView {
        return R.nib.textFieldFormView.firstView(owner: nil)!
    }
    
    func applyAppearance(appearance: TextFieldAppearence) {
        textField.applyAppearance(appearance: appearance)
    }

}
