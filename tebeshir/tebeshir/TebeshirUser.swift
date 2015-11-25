//
//  TebeshirUser.swift
//  tebeshir
//
//  Created by Yetkin Timocin on 10/06/15.
//  Copyright (c) 2015 basetech. All rights reserved.
//

import UIKit

class Student {
    
    var studentID : NSString!
    var facebookID : NSString!
    var email : NSString!
    var name : NSString!
    var pictureURL : String!
    
    init() {
        self.studentID = "TEST"
        self.facebookID = "TEST"
        self.email = "TEST"
        self.name = "TEST"
        self.pictureURL = "TEST"
    }
    
    func returnUserData() {
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                println("Error: \(error)")
            } else {
                
                let userName : NSString = result.valueForKey("name") as! NSString
                self.name = userName
                
                let userEmail : NSString = result.valueForKey("email") as! NSString
                self.email = userEmail
                
                let facebookID:String = result["id"] as AnyObject? as! String
                self.facebookID = facebookID
                
                let pictureURL = "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1"
                self.pictureURL = pictureURL
                
            }
            
        })
    }
    
    func dictionaryFromTebeshirUserObject() -> NSDictionary {
        return ["studentID": self.studentID.description,
                "facebookID": self.facebookID.description,
                "email": self.email.description,
                "name": self.name.description,
                "pictureURL": self.pictureURL]
    }
    
    func saveUserToDB() -> Bool {
        var request = NSMutableURLRequest(URL: NSURL(string: "http://tebeshir-api.cfapps.io/tebeshir/student")!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = dictionaryFromTebeshirUserObject()
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    var success = parseJSON["success"] as? Int
                    println("Succes: \(success)")
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        
        task.resume()
        return true
    }
    
    func checkIfUserExists() -> Bool {
        
        var request = NSMutableURLRequest(URL: NSURL(string: "http://tebeshir-api.cfapps.io/tebeshir/student")!)
        request.HTTPMethod = "GET"
        request.addValue("text/html", forHTTPHeaderField: "Content-Type")
        
        var session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if((error) != nil) {
                println(error.localizedDescription)
            }
            
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println(strData)
        })
        
        task.resume()
        return true
    }
    
}
