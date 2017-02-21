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
    
    convenience init?(userAPI: UserAPI) {
        guard let name = userAPI.name,
            let email = userAPI.email else{
                return nil
        }
        
        self.init(name: name, email: email)
    }
    
    convenience init(userDB: UserDB) {
        self.init(name: userDB.name, email: userDB.email)
    }
    
    func toUserDB() -> UserDB{
        return UserDB(name: name, email: email)
    }
}
