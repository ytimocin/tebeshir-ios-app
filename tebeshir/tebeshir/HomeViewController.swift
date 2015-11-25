//
//  HomeViewController.swift
//  tebeshir
//
//  Created by Yetkin Timocin on 04/06/15.
//  Copyright (c) 2015 basetech. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var avatar: UIImageView!
    
    var activeStudent = Student()
    var isSchoolView = NSNumber()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("inside homeViewController")
        self.view.backgroundColor = UIColor.whiteColor()
        
        let url:NSURL = NSURL(string: self.activeStudent.pictureURL)!
        let data = NSData(contentsOfURL: url)
        self.avatar.image = UIImage(data: data!)
        
        print("isSchoolView : \(isSchoolView)")
    }
    
}