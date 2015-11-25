//
//  ViewController.swift
//  tebeshir
//
//  Created by Yetkin Timocin on 12/05/15.
//  Copyright (c) 2015 basetech. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var student = Student()
    var facebookConnect = FacebookConnect()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.blackColor()
        
        if (facebookConnect.isConnectedToFacebook() == false) {
            print("facebook not connected 1")
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends", "user_about_me"]
            loginView.delegate = self
        } else {
            // okul secmeye yonlendirilecek mi
            // yoksa home a mi yonlendirilecek
            //userData()
            
            self.student = student.getActiveStudent()
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                let isConnectedToASchool  = self.student.studentConnectionStatus()
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    if (isConnectedToASchool) {
                        self.homeView(self.student)
                    } else {
                        self.schoolView(self.student)
                    }
                }
            }
            
        }
    }
    
    func homeView(student: Student) {
        let viewController =  self.storyboard!.instantiateViewControllerWithIdentifier("HomeViewController") as? HomeViewController
        viewController?.activeStudent = student
        viewController?.isSchoolView = 0
        self.presentViewController(viewController!, animated: true, completion: nil)
    }
    
    func schoolView(student: Student) {
        let viewController =  self.storyboard!.instantiateViewControllerWithIdentifier("HomeViewController") as? HomeViewController
        viewController?.activeStudent = student
        viewController?.isSchoolView = 1
        self.presentViewController(viewController!, animated: true, completion: nil)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil) {
            // Process error
        } else if result.isCancelled {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email") {
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

