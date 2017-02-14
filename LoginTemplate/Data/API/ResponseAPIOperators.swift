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
                return Result.failure(NSError(domain: LoginAPIClient.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: "Resposta não é um JSON"]))
            }
            return Result.success(JSONDict)
        } catch let error as NSError {
            return Result.failure(error)
        }
    }
}

extension ObservableType where E == Moya.Response {
    
    func processResponse() -> Observable<Moya.Response> {
        return flatMapLatest({ response -> Observable<Moya.Response> in
            if response.statusCode >= 200 && response.statusCode <= 299 {
                UserSession.sessionCredentialsUpdateWith(moyaResponse: response)
                return Observable.just(response)
            }else if response.statusCode == 401{
                UserSession.authExpire()
                
                switch response.data.asJSON{
                case .success(let JSONDict):
                    if let serverError = Mapper<ErrorAPI>().map(JSON: JSONDict){
                        return Observable.error(NSError(domain: LoginAPIClient.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: serverError.localizedDescription]))
                    }else{
                        return Observable.error(NSError(domain: LoginAPIClient.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: ["A autenticação falhou!"]]))
                    }
                case .failure(let error):
                    return Observable.error(error)
                }
            }else {
                switch response.data.asJSON{
                case .success(let JSONDict):
                    if let serverError = Mapper<ErrorAPI>().map(JSON: JSONDict){
                        return Observable.error(NSError(domain: LoginAPIClient.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: serverError.localizedDescription]))
                    }else{
                        return Observable.error(NSError(domain: LoginAPIClient.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: ["JSON (\(JSONDict)) não pôde ser mapeado"]]))
                    }
                case .failure(let error):
                    return Observable.error(error)
                }
            }
        })
    }
    
    func createAuthSession() -> Observable<Moya.Response> {
        return flatMapLatest { response -> Observable<Moya.Response> in
            do{
                if response.statusCode >= 200 && response.statusCode <= 299 {
                    let jsonAPIObject = try JSONSerialization.jsonObject(with: response.data) as! [String: Any]
                    
                    if let currentUser = UserAPI(JSON: jsonAPIObject){
                        UserSession.sessionCredentialsUpdateWith(moyaResponse: response, currentUser: currentUser)
                    }else{
                        return Observable.error(NSError(domain: LoginAPIClient.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: ["JSON (\(jsonAPIObject)) não pôde ser mapeado"]]))
                    }
                }
            }catch(let error){
                return Observable.error(error)
            }
            return Observable.just(response)
        }
    }
    
    func mapServerMessage() -> Observable<String?> {
        return flatMap { response -> Observable<String?> in
            
            switch response.data.asJSON{
            case .success(let JSONDict):
                if let serverMessage = Mapper<ErrorAPI>().map(JSON: JSONDict){
                    if response.statusCode >= 200 && response.statusCode <= 299{
                        return Observable.just(serverMessage.localizedDescription)
                    }else{
                        return Observable.error(NSError(domain: LoginAPIClient.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: [serverMessage.localizedDescription]]))
                    }
                }else{
                    return Observable.error(NSError(domain: LoginAPIClient.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: ["JSON (\(JSONDict)) não pôde ser mapeado"]]))
                }
            case .failure(let error):
                return Observable.error(error)
            }
        }
    }
}
