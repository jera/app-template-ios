//
//  UserSession.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 13/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import Moya
import RxSwift

let kNotificationCurrentUserChanged = "notificationCurrentUserChanged"
let kNotificationAuthExpired = "notificationAuthExpired"

class UserSession: NSObject, NSCoding{
    
    private static let currentSessionKey = "currentSessionKey"
    
    private var refreshCurrentUserDisposeBag: DisposeBag!
    
    private static var _currentSession: UserSession?
    static var currentSession: UserSession?{
        get{
            if let _currentSession = _currentSession{
                return _currentSession
            }
            
            if let data = UserDefaults.standard.object(forKey: currentSessionKey) as? Data,
                let currentSession = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? UserSession{
                
                _currentSession = currentSession
                
                return currentSession
            }
            
            return nil
        }
        
        set{
            _currentSession = newValue
            
            let data: Data?
            if let newValue = newValue{
                data = NSKeyedArchiver.archivedData(withRootObject: newValue) as Data?
            }else{
                data = nil
            }
            
            UserDefaults.standard.set(data, forKey: currentSessionKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    private(set) var uid: String
    private(set) var client: String
    private(set) var accessToken: String
    private(set) var currentUser: UserAPI{
        didSet{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationCurrentUserChanged), object: currentUser)
        }
    }
    
    
    var authHeaders: [String: String]{
        return [
            "access-token": accessToken,
            "uid": uid,
            "client": client
        ]
    }
    
    init(uid: String, client: String, accessToken: String, currentUser: UserAPI){
        self.uid = uid
        self.client = client
        self.accessToken = accessToken
        self.currentUser = currentUser
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        if let uid = aDecoder.decodeObject(forKey: "uid") as? String,
            let client = aDecoder.decodeObject(forKey: "client") as? String,
            let accessToken = aDecoder.decodeObject(forKey: "accessToken") as? String,
            let currentUser = aDecoder.decodeObject(forKey: "currentUser") as? UserAPI
        {
            self.init(uid: uid, client: client, accessToken: accessToken, currentUser: currentUser)
        }else{
            return nil
        }
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(client ,forKey: "client")
        aCoder.encode(accessToken, forKey: "accessToken")
        aCoder.encode(currentUser, forKey: "currentUser")
    }
    
    private class func sessionCredentialsUpdateWith(uid: String, client: String, accessToken: String, currentUser: UserAPI? = nil){
        if let currentUser = currentUser{
            
            self.currentSession = UserSession(uid: uid, client: client, accessToken: accessToken, currentUser: currentUser)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationCurrentUserChanged), object: currentUser)
            
            return
        }
        
        if let currentSession = currentSession{
            self.currentSession = UserSession(uid: uid, client: client, accessToken: accessToken, currentUser: currentSession.currentUser)
        }
    }
    
    class func sessionCredentialsUpdateWith(moyaResponse response: Moya.Response, currentUser: UserAPI? = nil){
        if let httpURLResponse = response.response as? HTTPURLResponse{
            if let uid = httpURLResponse.allHeaderFields["uid"] as? String,
                let client = httpURLResponse.allHeaderFields["client"] as? String,
                let accessToken = httpURLResponse.allHeaderFields["access-token"] as? String{
                
                self.sessionCredentialsUpdateWith(uid: uid, client: client, accessToken: accessToken, currentUser: currentUser)
            }
        }
    }
    
    class func logout(){
        if currentSession != nil{
            currentSession = nil
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationCurrentUserChanged), object: nil)
        }
    }
    
    class func authExpire(){
        if currentSession != nil{
            currentSession = nil
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationAuthExpired), object: nil)
        }
    }
    
    func refreshCurrentUser(){
        refreshCurrentUserDisposeBag = DisposeBag()
        LoginAPIClient.getCurrentUser().subscribe().addDisposableTo(refreshCurrentUserDisposeBag)
    }
    
}
