//
//  LoginAPIClient.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 13/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import Moya
import Moya_ObjectMapper
import ObjectMapper
import RxSwift

let provider = RxMoyaProvider<APITarget>( endpointClosure: { (target) -> Endpoint<APITarget> in
    
    var endpoint: Endpoint<APITarget> = Endpoint<APITarget>(url: "\(target.baseURL)\(target.path)",
        sampleResponseClosure: {.networkResponse(200, target.sampleData)},
        method: target.method,
        parameters: target.parameters,
        parameterEncoding: target.parameterEncoding,
        httpHeaderFields: [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Accept-Language": "pt-BR"
        ])
    
    if let authCredentials = UserSessionDataStore.retrieveUserSession()?.authHeaders {
        endpoint = endpoint.adding(newHTTPHeaderFields: authCredentials)
    }
    
    return endpoint
}, plugins: [NetworkActivityPlugin { (change) in
    switch change{
    case .began:
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    case .ended:
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    }, NetworkLoggerPlugin(verbose: true)])

enum APITarget {
    case Login(email: String, password: String)
    case LoginWithFacebook(token: String)
    case LoginWithGoogle(token: String)
    case ForgotPassword(email: String)
    case CreateNewAccount(name: String, email: String, password: String, image: UIImage?)
    case LogoutUser
    case EditAccount(name: String?, email: String?, password: String?, oldPassword: String?, image: UIImage?)
    case CurrentUser
}

extension APITarget: TargetType {
    var baseURL: URL {
        switch self {
        case .Login,
             .LoginWithFacebook,
             .LoginWithGoogle,
             .ForgotPassword,
             .CreateNewAccount,
             .CurrentUser,
             .LogoutUser,
             .EditAccount:
            return APIClient.baseURL as URL
        }
    }
    
    var path: String {
        switch self {
        case .Login:
            return "/auth/sign_in"
        case .LoginWithFacebook:
            return "/auth/facebook"
        case .LoginWithGoogle:
            return "/auth/google"
        case .ForgotPassword:
            return "/auth/password"
        case .CreateNewAccount:
            return "/auth"
        case .LogoutUser:
            return "/auth/sign_out"
        case .EditAccount:
            return "/auth"
        case .CurrentUser:
            return "/auth/edit"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .Login,
             .LoginWithFacebook,
             .LoginWithGoogle,
             .ForgotPassword,
             .CreateNewAccount:
            return .post
        case .CurrentUser:
            return .get
        case .LogoutUser:
            return .delete
        case .EditAccount:
            return .patch
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .LogoutUser,
             .CurrentUser:
            return nil
            
        case .Login(let email, let password):
            return [
                "email": email,
                "password": password
            ]
            
        case .LoginWithFacebook(let token):
            return [
                "access_token": token
            ]
            
        case .LoginWithGoogle(let token):
            return [
                "access_token": token
            ]
            
        case .ForgotPassword(let email):
            return [
                "email": email
            ]
            
        case .CreateNewAccount(let params):
            return[
                "name": params.name,
                "email": params.email,
                "password": params.password,
            ]
            
        case .EditAccount(let params):
            var bodyParams = [String : Any]()
            
            if let name = params.name{
                bodyParams["name"] = name
            }
            
            if let email = params.email{
                bodyParams["email"] = email
            }
            
            if let password = params.password{
                bodyParams["password"] = password
            }
            
            if let oldPassword = params.oldPassword{
                bodyParams["current_password"] = oldPassword
            }
            
            return bodyParams
        }
    }
    
    var parameterEncoding: ParameterEncoding{
        switch self{
        default:
            return JSONEncoding()
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .Login,
             .LoginWithFacebook,
             .LoginWithGoogle,
             .ForgotPassword,
             .CreateNewAccount,
             .LogoutUser,
             .CurrentUser:
            return .request
            
        case .EditAccount(let params):
            guard let userImage = params.image else { return .request }
            
            guard let userImageData = UIImageJPEGRepresentation(userImage, 0.8) else { return .request }
            
            let multipartFormsToSend = [Moya.MultipartFormData(
                provider: MultipartFormData.FormDataProvider.data(userImageData),
                name: "avatar",
                fileName: "avatar.jpg",
                mimeType: "image/jpg")
            ]
            
            return .upload(UploadType.multipart(multipartFormsToSend))
        }
    }
    
    var validate: Bool{
        return false
    }
}

struct APIClient {
    
    #if DEBUG
    static let domain = "staging.agropocket.jera.com.br"
    static let baseURLString = "http://staging.agropocket.jera.com.br"
    //    static let baseURLString = "http://localhost:3000"
    #else
    static let domain = "agropocket.com.br"
    static let baseURLString = "http://staging.agropocket.jera.com.br"
    #endif
    
    static let api = "/api"
    static let apiVersion = "/v1"
    
    static let baseURL = NSURL(string: "\(baseURLString)\(api)\(apiVersion)")!
    
    static func loginWith(email: String, password: String) -> Observable<UserAPI> {
        return provider
            .request(.Login(email: email, password: password))
            .processResponse(updateCurrentUser: true)
            .mapObject(UserAPI.self)
    }
    
    static func loginWithFacebook(token: String) -> Observable<UserAPI> {
        return provider
            .request(.LoginWithFacebook(token: token))
            .processResponse(updateCurrentUser: true)
            .mapObject(UserAPI.self)
    }
    
    static func forgotPasswordWith(email: String) -> Observable<String?> {
        return provider
            .request(.ForgotPassword(email: email))
            .processResponse()
            .mapServerMessage()
    }
    
    static func createNewAccount(name: String, email: String, password: String, image: UIImage? = nil) -> Observable<UserAPI>{
        return provider
            .request(.CreateNewAccount(name: name, email: email, password: password, image: image))
            .processResponse(updateCurrentUser: true)
            .mapObject(UserAPI.self)
    }
    
    static func editCurrentUserWith(name: String? = nil, email: String? = nil, password: String? = nil, oldPassword: String? = nil, image: UIImage? = nil) -> Observable<UserAPI>{
        return provider
            .request(.EditAccount(name: name, email: email, password: password, oldPassword: oldPassword, image: image))
            .processResponse(updateCurrentUser: true)
            .mapObject(UserAPI.self)
    }
    
    static func getCurrentUser() -> Observable<UserAPI>{
        return provider
            .request(.CurrentUser)
            .processResponse(updateCurrentUser: true)
            .mapObject(UserAPI.self)
    }
    
    static func logoutUser() -> Observable<Void> {
        return provider
            .request(.LogoutUser)
            .processResponse()
            .map({ (_) -> Void in
                return ()
            })
    }
}

extension APIClient{
    static let errorDomain = "APIClientErrorDomain"
    static func error(description: String, code: Int = 0) -> NSError{
        return NSError(domain: errorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
}
