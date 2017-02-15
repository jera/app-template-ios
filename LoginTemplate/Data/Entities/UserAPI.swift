//
//  UserAPI.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 13/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import ObjectMapper

class UserAPI: Mappable {
    var name: String?
    var email: String?
    
    init() {}
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        email <- map["email"]
    }
}
