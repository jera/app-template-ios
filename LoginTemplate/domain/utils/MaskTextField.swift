//
//  MaskTextField.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 27/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit
import Material
import RxSwift
import NSStringMask

enum FieldMask {
    case cpf
    case phone
    
    var placeholder: String {
        switch self {
        case .cpf:
            return "_"
        case .phone:
            return "_"
        }
    }
    
    var mask: NSStringMask {
        switch self {
        case .cpf:
            return NSStringMask(pattern: "(\\d{3}).(\\d{3}).(\\d{3})-(\\d{2})", placeholder: placeholder)
        case .phone:
            return NSStringMask(pattern: "\\((\\d{2})\\) (\\d{9})", placeholder: placeholder)
        }
    }
}

class MaskTextField: TextField {

    var fieldMask: FieldMask?
    override var text: String! {
        didSet {
            if let fieldMask = fieldMask, let text = text {
                if !text.isEmpty {
                    super.text = fieldMask.mask.format(text)
                }else {
                    super.text = ""
                }
                
                rawText.value = fieldMask.mask.validCharacters(for: text)
            }else {
                rawText.value = text
            }
        }
    }
    
    fileprivate let rawText = Variable("")
    lazy var rawTextObservable: Observable<String> = {
        return self.rawText.asObservable().distinctUntilChanged()
    }()
    
    var leftOffset: CGFloat = 0 {
        didSet {
            leftView = UIView()
            leftViewOffset = -bounds.size.height + leftOffset
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        delegate = self
        
        _ = rx.text.takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self] (text) in
            guard let strongSelf = self else { return }
            
            guard let text = text else {
                strongSelf.rawText.value = ""
                return
            }
            
            if let fieldMask = strongSelf.fieldMask {
                strongSelf.rawText.value = fieldMask.mask.validCharacters(for: text)
            }else {
                strongSelf.rawText.value = text
            }
        })
    }

}

extension MaskTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let fieldMask = fieldMask {
            var _range = range
            
            if string.isEmpty {
                //Deleting character(s)
                let rawText = fieldMask.mask.validCharacters(for: textField.text)!
                var formattedText = (textField.text! as NSString).replacingCharacters(in: _range, with: string)
                var rawFormattedText = fieldMask.mask.validCharacters(for: formattedText)!
                
                while(rawFormattedText == rawText) {
                    guard _range.location - 1 >= 0 else {
                        break
                    }
                    
                    _range = NSRange(location: _range.location - 1, length: 1)
                    formattedText = (textField.text! as NSString).replacingCharacters(in: _range, with: string)
                    
                    rawFormattedText = fieldMask.mask.validCharacters(for: formattedText)!
                }
                
                textField.text = rawFormattedText
                textField.selectedTextRange = _range.toStartTextRange(textInput: textField)
            }else {
                //Adding character(s)
                let startFormattedText = (textField.text! as NSString).replacingCharacters(in: _range, with: string)
                let rawText = fieldMask.mask.validCharacters(for: startFormattedText)
                let formattedText = fieldMask.mask.format(rawText)!

                var index = 0
                for formattedCharacter in formattedText {
                    if formattedCharacter == "_"{
                        break
                    }
                    index += 1
                }
                
                textField.text = rawText

                textField.selectedTextRange = _range.toEndTextRange(textInput: textField, offset: index)

            }
            return false
        }
        return true
    }
}

extension NSRange {
    func toTextRange(textInput: UITextInput) -> UITextRange? {
        if let rangeStart = textInput.position(from: textInput.beginningOfDocument, offset: location),
            let rangeEnd = textInput.position(from: rangeStart, offset: length) {
            return textInput.textRange(from: rangeStart, to: rangeEnd)
        }
        return nil
    }
    
    func toStartTextRange(textInput: UITextInput) -> UITextRange? {
        if let rangeStart = textInput.position(from: textInput.beginningOfDocument, offset: location) {
            return textInput.textRange(from: rangeStart, to: rangeStart)
        }
        return nil
    }
    
    func toEndTextRange(textInput: UITextInput, offset: Int) -> UITextRange? {
        if let rangeStart = textInput.position(from: textInput.beginningOfDocument, offset: 0),
            let rangeEnd = textInput.position(from: rangeStart, offset: offset) {
            return textInput.textRange(from: rangeEnd, to: rangeEnd)
        }
        return nil
    }
}
