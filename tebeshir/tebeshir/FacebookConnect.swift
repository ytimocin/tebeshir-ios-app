//
//  FacebookConnect.swift
//  tebeshir
//
//  Created by Yetkin Timocin on 20/06/15.
//  Copyright (c) 2015 basetech. All rights reserved.
//

import UIKit
import Foundation

class FacebookConnect {
    
    func isConnectedToFacebook() -> Bool {
        var result : Bool
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            print("facebook not connected 2")
            result = false
        } else {
            result = true
        }
        return result
    }
    
    func returnUserData() -> Student {
        let student = Student()
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                let userName : NSString = result.valueForKey("name") as! NSString
                student.name = userName
                
                let userEmail : NSString = result.valueForKey("email") as! NSString
                student.email = userEmail
                
                let facebookID:String = result["id"] as AnyObject? as! String
                student.facebookID = facebookID
                
                let pictureURL = "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1"
                student.pictureURL = pictureURL
            }
        })
        return student
    }
    
}
