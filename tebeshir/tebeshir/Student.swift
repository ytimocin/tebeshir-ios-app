//
//  TebeshirUser.swift
//  tebeshir
//
//  Created by Yetkin Timocin on 10/06/15.
//  Copyright (c) 2015 basetech. All rights reserved.
//

import UIKit

class Student {
    
    var tebeshirID : NSString!
    var facebookID : NSString!
    var email : NSString!
    var name : NSString!
    var pictureURL : String!
    
    var facebookConnect : FacebookConnect
    
    init() {
        self.tebeshirID = "TEST"
        self.facebookID = "TEST"
        self.email = "TEST"
        self.name = "TEST"
        self.pictureURL = "TEST"
        self.facebookConnect = FacebookConnect()
    }
    
    func dictionaryFromTebeshirUserObject() -> NSDictionary {
        return ["tebeshirID": self.tebeshirID.description,
            "facebookID": self.facebookID.description,
            "email": self.email.description,
            "name": self.name.description,
            "pictureURL": self.pictureURL]
    }
    
    func saveUserToDB() -> Bool {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://tebeshir-api.cfapps.io/tebeshir/student/register")!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let params = dictionaryFromTebeshirUserObject()
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])
        } catch {
            request.HTTPBody = nil
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(error != nil) {
                print(error!.localizedDescription)
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    print("parseJSON : \(parseJSON)")
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        
        task.resume()
        return true
    }
    
    func studentConnectionStatus() -> Bool {
        var result = false
        let request = NSMutableURLRequest(URL: NSURL(string: "http://tebeshir-api.cfapps.io/tebeshir/connect/student/\(self.tebeshirID)")!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if((error) != nil) {
                print(error!.localizedDescription)
            }
            
            print("data from studentConnectionStatus: \(data!.description)")
            
            if(data != "<>") {
                result = true
            }
            
            let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("strData from studentConnectionStatus: \(strData)")
        })
        
        task.resume()
        return result
    }
    
    func getStudentFromDB() -> Student {
        let student = Student()
        let request = NSMutableURLRequest(URL: NSURL(string: "http://tebeshir-api.cfapps.io/tebeshir/student/facebookID/\(self.facebookID)")!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if((error) != nil) {
                print(error!.localizedDescription)
            }
            
            let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("strData from getStudentFromDB: \(strData)")
        })
        
        task.resume()
        return student
    }
    
    func getActiveStudent() -> Student {
        
        var currentStudent: Student = self.facebookConnect.returnUserData()
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            currentStudent.saveUserToDB()
            
            dispatch_after(delayTime, dispatch_get_main_queue()) {
             
                currentStudent = currentStudent.getStudentFromDB()
                
            }
            
            /*
            let data:NSData = NSJSONSerialization.dataWithJSONObject(currentStudent.dictionaryFromTebeshirUserObject(), options: NSJSONWritingOptions.PrettyPrinted, error: nil)!
            
            var datastring = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            self.student.saveUserToDB()
            
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.homeView(self.student)
            }
            */
        }
        
        return currentStudent
    }
    
}
