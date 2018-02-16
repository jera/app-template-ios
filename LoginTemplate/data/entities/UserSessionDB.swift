//
//  UserSessionStorage.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 14/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import Foundation

class UserSessionDB: NSObject, NSCoding {
    private(set) var uid: String
    private(set) var client: String
    private(set) var accessToken: String
    private(set) var currentUser: UserDB
    
    init(uid: String, client: String, accessToken: String, currentUser: UserDB) {
        self.uid = uid
        self.client = client
        self.accessToken = accessToken
        self.currentUser = currentUser
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        if let uid = aDecoder.decodeObject(forKey: "uid") as? String,
            let client = aDecoder.decodeObject(forKey: "client") as? String,
            let accessToken = aDecoder.decodeObject(forKey: "accessToken") as? String,
            let currentUser = aDecoder.decodeObject(forKey: "currentUser") as? UserDB {
            self.init(uid: uid, client: client, accessToken: accessToken, currentUser: currentUser)
        }else {
            return nil
        }
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(client, forKey: "client")
        aCoder.encode(accessToken, forKey: "accessToken")
        aCoder.encode(currentUser, forKey: "currentUser")
    }
}
