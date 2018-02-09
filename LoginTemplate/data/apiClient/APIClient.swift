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

class APIClientHost {
    #if DEBUG
    static let baseURLString = "http://staging.agropocket.jera.com.br"
    #else
    static let baseURLString = "http://staging.agropocket.jera.com.br"
    #endif

    static let api = "/api"
    static let apiVersion = "/v1"

    static var baseURL = NSURL(string: "\(baseURLString)\(api)\(apiVersion)")!
}

let provider = MoyaProvider<APITarget>( endpointClosure: { (target) -> Endpoint<APITarget> in
    
    return Endpoint<APITarget>(url: "\(target.baseURL)\(target.path)",
        sampleResponseClosure: {.networkResponse(200, target.sampleData)},
        method: target.method,
        task: target.task,
        httpHeaderFields: target.headers)
    
}, plugins: [NetworkActivityPlugin { (change, _)  in
    switch change {
    case .began:
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    case .ended:
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    }, NetworkLoggerPlugin(verbose: true)])

enum APITarget {
    case Login(email: String, password: String)
    case LoginWithFacebook(token: String)
    case LoginWithGoogle(token: String)
    case ForgotPassword(email: String)
    case CreateNewAccount(name: String, email: String, cpf: String, password: String, image: UIImage?)
    case LogoutUser
    case EditAccount(name: String?, email: String?, cpf: String?, password: String?, oldPassword: String?, image: UIImage?)
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
            return APIClientHost.baseURL as URL
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
    
    var headers: [String: String]? {
        var httpHeaderFields: [String: String] = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Accept-Language": "pt-BR"
        ]
        
        if let authCredentials = UserSessionInteractor.shared.userSession?.authHeaders {
            
            authCredentials.forEach({ (key, value) in
                httpHeaderFields[key] = value
            })
        }
        
        return httpHeaderFields
    }

    var sampleData: Data {
        switch self {
        default:
            return Data()
        }
    }

    var task: Task {
        switch self {
        case .Login(let email, let password):
            let bodyParams: [String: Any] = [
                "email": email,
                "password": password
            ]
            return Task.requestParameters(parameters: bodyParams, encoding: JSONEncoding())
            
        case .LoginWithFacebook(let token):
            return Task.requestParameters(parameters: [ "access_token": token ], encoding: JSONEncoding())
            
        case .LoginWithGoogle(let token):
            return Task.requestParameters(parameters: [ "access_token": token ], encoding: JSONEncoding())
            
        case .ForgotPassword(let email):
            return Task.requestParameters(parameters: [ "email": email ], encoding: JSONEncoding())
            
        case .CreateNewAccount(let params):
            let bodyParams: [String: Any] = [
                "name": params.name,
                "email": params.email,
                "password": params.password
            ]
            
            return Task.requestParameters(parameters: bodyParams, encoding: JSONEncoding())
            
        case .EditAccount(let params):
            var bodyParams = [String: Any]()
            
            if let name = params.name {
                bodyParams["name"] = name
            }
            
            if let email = params.email {
                bodyParams["email"] = email
            }
            
            if let password = params.password {
                bodyParams["password"] = password
            }
            
            if let oldPassword = params.oldPassword {
                bodyParams["current_password"] = oldPassword
            }
            
            guard let userImage = params.image, let userImageData = UIImageJPEGRepresentation(userImage, 0.8) else {
                return .requestParameters(parameters: bodyParams, encoding: JSONEncoding())
                
            }
            
            let multipartFormsToSend = [Moya.MultipartFormData(
                provider: MultipartFormData.FormDataProvider.data(userImageData),
                name: "avatar",
                fileName: "avatar.jpg",
                mimeType: "image/jpg")
            ]
            
            return Task.uploadCompositeMultipart(multipartFormsToSend, urlParameters: bodyParams)
        
        default:
            return Task.requestPlain
        }
    }
}

protocol APIClientProtocol {
    func loginWith(email: String, password: String) -> Single<UserAPI>
    func loginWithFacebook(token: String) -> Single<UserAPI>
    func loginWithGoogle(token: String) -> Single<UserAPI>
    func forgotPasswordWith(email: String) -> Single<String?>
    func createNewAccount(name: String, email: String, cpf: String, password: String, image: UIImage?) -> Single<UserAPI>
    func editCurrentUserWith(name: String?, email: String?, cpf: String?, password: String?, oldPassword: String?, image: UIImage?) -> Single<UserAPI>
    func getCurrentUser() -> Single<UserAPI>
    func logoutUser() -> Single<Void>
}

struct APIClient: APIClientProtocol {
    func loginWith(email: String, password: String) -> Single<UserAPI> {
        return provider.rx
            .request(.Login(email: email, password: password))
            .processResponse(updateCurrentUser: true)
            .mapObject(UserAPI.self)
    }

    func loginWithFacebook(token: String) -> Single<UserAPI> {
        return provider.rx
            .request(.LoginWithFacebook(token: token))
            .processResponse(updateCurrentUser: true)
            .mapObject(UserAPI.self)
    }

    func loginWithGoogle(token: String) -> Single<UserAPI> {
        return provider.rx
            .request(.LoginWithGoogle(token: token))
            .processResponse(updateCurrentUser: true)
            .mapObject(UserAPI.self)
    }

    func forgotPasswordWith(email: String) -> Single<String?> {
        return provider.rx
            .request(.ForgotPassword(email: email))
            .processResponse()
            .mapServerMessage()
    }

    func createNewAccount(name: String, email: String, cpf: String, password: String, image: UIImage? = nil) -> Single<UserAPI> {
        return provider.rx
            .request(.CreateNewAccount(name: name, email: email, cpf: cpf, password: password, image: image))
            .processResponse(updateCurrentUser: true)
            .mapObject(UserAPI.self)
    }

    func editCurrentUserWith(name: String? = nil, email: String? = nil, cpf: String? = nil, password: String? = nil, oldPassword: String? = nil, image: UIImage? = nil) -> Single<UserAPI> {
        return provider.rx
            .request(.EditAccount(name: name, email: email, cpf: cpf, password: password, oldPassword: oldPassword, image: image))
            .processResponse(updateCurrentUser: true)
            .mapObject(UserAPI.self)
    }

    func getCurrentUser() -> Single<UserAPI> {
        return provider.rx
            .request(.CurrentUser)
            .processResponse(updateCurrentUser: true)
            .mapObject(UserAPI.self)
    }

    func logoutUser() -> Single<Void> {
        return provider.rx
            .request(.LogoutUser)
            .processResponse()
            .map({ (_) -> Void in
                return ()
            })
    }
}

extension APIClient {
    static let errorDomain = "APIClient"
    static func error(description: String, code: Int = 0) -> NSError {
        return NSError(domain: errorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
}
