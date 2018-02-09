//
//  ResponseAPIOperators.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 13/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper
import Result

struct SessionCredentials {
    var uid: String
    var client: String
    var accessToken: String
}

extension Data {
    var asJSON: Result<[String: Any], NSError> {
        do {
            guard let JSONDict = try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] else {
                return Result.failure(APIClient.error(description: R.string.localizable.messageJsonInvalid()))
            }
            return Result.success(JSONDict)
        } catch let error as NSError {
            return Result.failure(error)
        }
    }
}

extension Moya.Response {
    var sessionCredentails: SessionCredentials? {
        if let httpURLResponse = response {
            if let uid = httpURLResponse.allHeaderFields["uid"] as? String,
                let client = httpURLResponse.allHeaderFields["client"] as? String,
                let accessToken = httpURLResponse.allHeaderFields["access-token"] as? String {

                return SessionCredentials(uid: uid, client: client, accessToken: accessToken)
            }
        }

        return nil
    }
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
 
    func processResponse(updateCurrentUser: Bool = false) -> Single<Moya.Response> {
        return flatMap({ (response) -> Single<Moya.Response> in
            if response.statusCode >= 200 && response.statusCode <= 299 {
                if updateCurrentUser {
                    let jsonAPIObject = try JSONSerialization.jsonObject(with: response.data) as! [String: Any]
                    
                    if let userAPI = UserAPI(JSON: jsonAPIObject) {
                        do {
                            if let credentiails = response.sessionCredentails {
                                try UserSessionInteractor.shared.userSessionUpdateWith(uid: credentiails.uid,
                                                                                       client: credentiails.client,
                                                                                       accessToken: credentiails.accessToken,
                                                                                       userAPI: userAPI)
                            }
                        }catch(let error) {
                            return Single.error(error)
                        }
                    }else {
                        
                        return Single.error(APIClient.error(description: R.string.localizable.messageUserJson("\(jsonAPIObject)")))
                    }
                }else {
                    do {
                        if let credentiails = response.sessionCredentails {
                            try UserSessionInteractor.shared.userSessionUpdateWith(uid: credentiails.uid,
                                                                                   client: credentiails.client,
                                                                                   accessToken: credentiails.accessToken,
                                                                                   userAPI: nil)
                        }
                    }catch(let error) {
                        return Single.error(error)
                    }
                }
                return Single.just(response)
            }else if response.statusCode == 401 {
                UserSessionInteractor.shared.expire()
                
                switch response.data.asJSON {
                case .success(let JSONDict):
                    if let errorAPI = Mapper<ErrorAPI>().map(JSON: JSONDict) {
                        return Single.error(APIClient.error(description: errorAPI.localizedDescription))
                    }else {
                        return Single.error(APIClient.error(description: R.string.localizable.messageAuthenticationFailed()))
                    }
                case .failure(let error):
                    return Single.error(error)
                }
            }else {
                switch response.data.asJSON {
                case .success(let JSONDict):
                    if let errorAPI = Mapper<ErrorAPI>().map(JSON: JSONDict) {
                        return Single.error(APIClient.error(description: errorAPI.localizedDescription))
                    }else {
                        return Single.error(APIClient.error(description: R.string.localizable.messageJson("\(JSONDict)")))
                    }
                case .failure(let error):
                    return Single.error(error)
                }
            }
        })
    }
    
    func mapServerMessage() -> Single<String?> {
        return flatMap { response -> Single<String?> in
            
            switch response.data.asJSON {
            case .success(let JSONDict):
                if let errorAPI = Mapper<ErrorAPI>().map(JSON: JSONDict) {
                    if response.statusCode >= 200 && response.statusCode <= 299 {
                        return Single.just(errorAPI.localizedDescription)
                    }else {
                        return Single.error(APIClient.error(description: errorAPI.localizedDescription))
                    }
                }else {
                    return Single.error(APIClient.error(description: R.string.localizable.messageJson("\(JSONDict)")))
                }
            case .failure(let error):
                return Single.error(error)
            }
        }
    }
    
}

extension ObservableType where E == Moya.Response {
    
//    func mapServerMessage() -> Observable<String?> {
//        return flatMap { response -> Observable<String?> in
//
//            switch response.data.asJSON {
//            case .success(let JSONDict):
//                if let errorAPI = Mapper<ErrorAPI>().map(JSON: JSONDict) {
//                    if response.statusCode >= 200 && response.statusCode <= 299 {
//                        return Observable.just(errorAPI.localizedDescription)
//                    }else {
//                        return Observable.error(APIClient.error(description: errorAPI.localizedDescription))
//                    }
//                }else {
//                    return Observable.error(APIClient.error(description: R.string.localizable.messageJson("\(JSONDict)")))
//                }
//            case .failure(let error):
//                return Observable.error(error)
//            }
//        }
//    }

//    func processResponse(updateCurrentUser: Bool = false) -> Observable<Moya.Response> {
//        return flatMapLatest({ response -> Observable<Moya.Response> in
//            if response.statusCode >= 200 && response.statusCode <= 299 {
//                if updateCurrentUser {
//                    let jsonAPIObject = try JSONSerialization.jsonObject(with: response.data) as! [String: Any]
//
//                    if let userAPI = UserAPI(JSON: jsonAPIObject) {
//                        do {
//                            if let credentiails = response.sessionCredentails {
//                                try UserSessionInteractor.shared.userSessionUpdateWith(uid: credentiails.uid,
//                                                                                client: credentiails.client,
//                                                                                accessToken: credentiails.accessToken,
//                                                                                userAPI: userAPI)
//                            }
//                        }catch(let error) {
//                            return Observable.error(error)
//                        }
//                    }else {
//
//                        return Observable.error(APIClient.error(description: R.string.localizable.messageUserJson("\(jsonAPIObject)")))
//                    }
//                }else {
//                    do {
//                        if let credentiails = response.sessionCredentails {
//                            try UserSessionInteractor.shared.userSessionUpdateWith(uid: credentiails.uid,
//                                                                            client: credentiails.client,
//                                                                            accessToken: credentiails.accessToken,
//                                                                            userAPI: nil)
//                        }
//                    }catch(let error) {
//                        return Observable.error(error)
//                    }
//                }
//                return Observable.just(response)
//            }else if response.statusCode == 401 {
//                UserSessionInteractor.shared.expire()
//
//                switch response.data.asJSON {
//                case .success(let JSONDict):
//                    if let errorAPI = Mapper<ErrorAPI>().map(JSON: JSONDict) {
//                        return Observable.error(APIClient.error(description: errorAPI.localizedDescription))
//                    }else {
//                        return Observable.error(APIClient.error(description: R.string.localizable.messageAuthenticationFailed()))
//                    }
//                case .failure(let error):
//                    return Observable.error(error)
//                }
//            }else {
//                switch response.data.asJSON {
//                case .success(let JSONDict):
//                    if let errorAPI = Mapper<ErrorAPI>().map(JSON: JSONDict) {
//                        return Observable.error(APIClient.error(description: errorAPI.localizedDescription))
//                    }else {
//                        return Observable.error(APIClient.error(description: R.string.localizable.messageJson("\(JSONDict)")))
//                    }
//                case .failure(let error):
//                    return Observable.error(error)
//                }
//            }
//        })
//    }
}



