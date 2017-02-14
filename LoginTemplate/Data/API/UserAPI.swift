//
//  UserAPI.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 13/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import ObjectMapper

class UserAPI: NSObject, NSCoding, Mappable {
    var name: String?
    var email: String?
//    var avatar: Image?
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        email <- map["email"]
//        avatar <- map["avatar"]
    }
    
    //NScoding
    required override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.email = aDecoder.decodeObject(forKey: "email") as? String
//        self.avatar = aDecoder.decodeObject(forKey: "avatar") as? Image
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name ,forKey: "name")
        aCoder.encode(email ,forKey: "email")
//        aCoder.encode(avatar ,forKey: "avatar")
    }
}
