//
//  CPF.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/24/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

public class CPF {
    
    public class func gerarCPFValido() -> String {
        
        var cpf = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        var temp1 = 0, temp2 = 0
        
        for i in 0...8 {
            cpf[i] = (Int)(arc4random_uniform(9))
            temp1 += cpf[i] * (10 - i)
            temp2 += cpf[i] * (11 - i)
        }
        
        temp1 %= 11
        cpf[9] = temp1 < 2 ? 0 : 11-temp1
        
        temp2 += cpf[9] * 2
        temp2 %= 11
        cpf[10] = temp2 < 2 ? 0 : 11-temp2
        
        return "\(cpf[0])\(cpf[1])\(cpf[2]).\(cpf[3])\(cpf[4])\(cpf[5]).\(cpf[6])\(cpf[7])\(cpf[8])-\(cpf[9])\(cpf[10])"
        
    }
    
    public class func validate(cpf: String) -> Bool {
        
        if cpf.characters.count == 11 {
            
            let d1 = Int(cpf.substring(with: cpf.index(cpf.startIndex, offsetBy: 9)..<cpf.index(cpf.startIndex, offsetBy: 10)))!
            let d2 = Int(cpf.substring(with: cpf.index(cpf.startIndex, offsetBy: 10)..<cpf.index(cpf.startIndex, offsetBy: 11)))!
            
            var temp1 = 0, temp2 = 0
            
            for i in 0...8 {
                
                let char = Int(cpf.substring(with: cpf.index(cpf.startIndex, offsetBy: i)..<cpf.index(cpf.startIndex, offsetBy: i+1)))!
                
                temp1 += char * (10 - i)
                temp2 += char * (11 - i)
            }
            
            temp1 %= 11
            temp1 = temp1 < 2 ? 0 : 11-temp1
            
            temp2 += temp1 * 2
            temp2 %= 11
            temp2 = temp2 < 2 ? 0 : 11-temp2
            
            if temp1 == d1 && temp2 == d2 {
                return true
            }
            
        }
        
        return false
    }
    
}
