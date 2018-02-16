//
//  RequestResponse.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 16/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

enum RequestResponse<T> {
    case new
    case loading
    case success(responseObject: T)
    case failure(error: Error)
    case cancelled
}
