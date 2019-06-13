//
//  PasswordAuth.swift
//  Hello World!
//
//  Created by Marty McFly on 2019/05/31.
//  Copyright © 2019 empty. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class PasswordAuth: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //jailDetection()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func authenticate(_ sender: Any) {
        // view.endEditing(true)
        guard let username = txtUsername.text, username.count > 0 else{return}
        guard let password = txtPassword.text, password.count > 0 else{return}
        let retrievedPassword:String? = KeychainWrapper.standard.string(forKey: txtUsername.text!, withAccessibility: .whenPasscodeSetThisDeviceOnly)
        
        if(password == retrievedPassword){
            //self.showAlert("Correct credentails")
            self.performSegue(withIdentifier: "sentiment", sender: self)
            
        }else if(retrievedPassword != txtPassword.text!){
            self.showAlert("Username or password incorrect")
        
        }
    }
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    func jailDetection(){
        if TARGET_IPHONE_SIMULATOR != 1{
            if FileManager.default.fileExists(atPath: "Applications/Cydia.app") || FileManager.default.fileExists(atPath: "/Library/MobileSubtrate/MobileSubstrate.dylib") ||  FileManager.default.fileExists(atPath: "/bin/bash")
                || FileManager.default.fileExists(atPath: "/usr/sbin/sshd")
                || FileManager.default.fileExists(atPath: "/etc/apt")
                || FileManager.default.fileExists(atPath: "/private/var/lib/apt/")
                || UIApplication.shared.canOpenURL(URL(string:"cydia://package/com.example.package")!) { self.showAlert("Device is jailbroken")}
        }
        let stringToWrite = "Jailbreak Test"
        do
        {
            try stringToWrite.write(toFile:"/private/JailbreakTest.txt", atomically:true, encoding:String.Encoding.utf8)
            showAlert("Device is jailbroken")
        }catch{
            return
        }
        
        
    }
}
