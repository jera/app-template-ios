//
//  ErrorAPI.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 14/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import ObjectMapper

class ErrorAPI: Mappable {
    var messages: [String]?
    var message: String?
    
    var errors: [String]?
    var error: String?
    
    //TODO: remover para camada do interactor ou do presenter
    var localizedDescription: String{
        if let message = message{
            return message
        }
        
        if let messages = messages{
            return messages.map({ (error) -> String in
                return "- \(error)"
            }).joined(separator: "\n")
        }
        
        if let error = error{
            return error
        }
        
        if let errors = errors{
            return errors.map({ (error) -> String in
                return "- \(error)"
            }).joined(separator: "\n")
        }
        
        return "Um erro desconhecido ocorreu"
    }
    
    init() {}
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        errors <- map["errors"]
        error <- map["error"]
        
        messages <- map["messages"]
        message <- map["message"]
    }
}
