//
//  ResponseAPIOperators.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 13/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

//
//  Observable.swift
//  agroPocket
//
//  Created by Junio Moquiuti on 12/16/16.
//  Copyright © 2016 Jera. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper
import Result

extension Data{
    var asJSON: Result<[String: Any], NSError>{
        do {
            guard let JSONDict = try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] else{
                return Result.failure(NSError(domain: APIClient.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: "Resposta não é um JSON"]))
            }
            return Result.success(JSONDict)
        } catch let error as NSError {
            return Result.failure(error)
        }
    }
}

extension ObservableType where E == Moya.Response {
    
    func processResponse(updateCurrentUser: Bool = false) -> Observable<Moya.Response> {
        return flatMapLatest({ response -> Observable<Moya.Response> in
            if response.statusCode >= 200 && response.statusCode <= 299 {
                if updateCurrentUser{
                    let jsonAPIObject = try JSONSerialization.jsonObject(with: response.data) as! [String: Any]
                    
                    if let userAPI = UserAPI(JSON: jsonAPIObject){
                        do{
                            try UserSessionInteractor.userSessionUpdateWith(moyaResponse: response, userAPI: userAPI)
                        }catch(let error){
                            return Observable.error(error)
                        }
                    }else{
                        return Observable.error(NSError(domain: APIClient.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: ["JSON de usuário (\(jsonAPIObject)) não pôde ser mapeado"]]))
                    }
                }else{
                    do{
                        try UserSessionInteractor.userSessionUpdateWith(moyaResponse: response)
                    }catch(let error){
                        return Observable.error(error)
                    }
                }
                return Observable.just(response)
            }else if response.statusCode == 401{
                UserSessionInteractor.authExpire()
                
                switch response.data.asJSON{
                case .success(let JSONDict):
                    if let serverError = Mapper<ErrorAPI>().map(JSON: JSONDict){
                        return Observable.error(NSError(domain: APIClient.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: serverError.localizedDescription]))
                    }else{
                        return Observable.error(NSError(domain: APIClient.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: ["A autenticação falhou!"]]))
                    }
                case .failure(let error):
                    return Observable.error(error)
                }
            }else {
                switch response.data.asJSON{
                case .success(let JSONDict):
                    if let serverError = Mapper<ErrorAPI>().map(JSON: JSONDict){
                        return Observable.error(NSError(domain: APIClient.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: serverError.localizedDescription]))
                    }else{
                        return Observable.error(NSError(domain: APIClient.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: ["JSON (\(JSONDict)) não pôde ser mapeado"]]))
                    }
                case .failure(let error):
                    return Observable.error(error)
                }
            }
        })
    }
    
//    func createOrUpdateAuthSession() -> Observable<Moya.Response> {
//        return flatMapLatest { response -> Observable<Moya.Response> in
//            do{
//                if response.statusCode >= 200 && response.statusCode <= 299 {
//                    let jsonAPIObject = try JSONSerialization.jsonObject(with: response.data) as! [String: Any]
//                    
//                    if let userAPI = UserAPI(JSON: jsonAPIObject){
//                        do{
//                            try UserSessionInteractor.userSessionUpdateWith(moyaResponse: response, userAPI: userAPI)
//                        }catch(let error){
//                            return Observable.error(error)
//                        }
//                    }else{
//                        return Observable.error(NSError(domain: APIClient.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: ["JSON de usuário (\(jsonAPIObject)) não pôde ser mapeado"]]))
//                    }
//                }
//            }catch(let error){
//                return Observable.error(error)
//            }
//            return Observable.just(response)
//        }
//    }
    
    func mapServerMessage() -> Observable<String?> {
        return flatMap { response -> Observable<String?> in
            
            switch response.data.asJSON{
            case .success(let JSONDict):
                if let serverMessage = Mapper<ErrorAPI>().map(JSON: JSONDict){
                    if response.statusCode >= 200 && response.statusCode <= 299{
                        return Observable.just(serverMessage.localizedDescription)
                    }else{
                        return Observable.error(NSError(domain: APIClient.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: [serverMessage.localizedDescription]]))
                    }
                }else{
                    return Observable.error(NSError(domain: APIClient.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: ["JSON (\(JSONDict)) não pôde ser mapeado"]]))
                }
            case .failure(let error):
                return Observable.error(error)
            }
        }
    }
}
