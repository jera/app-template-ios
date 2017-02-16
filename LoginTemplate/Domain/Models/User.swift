//
//  User.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 15/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

class User {
    var name: String
    var email: String
    
    init(name: String, email: String){
        self.name = name
        self.email = email
    }
    
    init?(userAPI: UserAPI) {
        guard let name = userAPI.name,
            let email = userAPI.email else{
                return nil
        }
        
        self.name = name
        self.email = email
    }
    
    func toUserDB() -> UserDB{
        return UserDB(name: name, email: email)
    }
}
