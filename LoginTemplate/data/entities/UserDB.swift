//
//  UserDB.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 15/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import Foundation

class UserDB: NSObject, NSCoding {
    var name: String
    var email: String
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let name = aDecoder.decodeObject(forKey: "name") as? String,
            let email = aDecoder.decodeObject(forKey: "email") as? String {
            self.name = name
            self.email = email
        }else {
            return nil
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(email, forKey: "email")
    }
}
