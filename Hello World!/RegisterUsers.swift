//
//  RegisterUsers.swift
//  Hello World!
//
//  Created by Marty McFly on 2019/05/31.
//  Copyright © 2019 empty. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class RegisterUsers: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassowrd: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //jailDetection()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnRegister(_ sender: Any) {
        if(txtUsername.text!.isEmpty || txtPassword.text!.isEmpty || txtConfirmPassowrd.text!.isEmpty
        )
        {
            showAlert("Fill in all the registeration details")
            return
        }
        else if(txtPassword.text != txtConfirmPassowrd.text) {
            showAlert("Passwords do not match")
            return
        }
        else if(txtPassword.text!.count != 16 || txtConfirmPassowrd.text!.count != 16){
            showAlert("Minimum character length of 16 required for password")
        }
        let username = txtUsername.text!
        let password = txtPassword.text!
        let saveSuccessful: Bool = KeychainWrapper.standard.set(password, forKey: username, withAccessibility: .whenPasscodeSetThisDeviceOnly)
//        (password, forKey: username, KeychainItemAccessibility: .whenUnlocked)
        
        if saveSuccessful{
                self.performSegue(withIdentifier: "login", sender: self)
            
        }else{
            showAlert("Error while registering users")
            return
        }
        
        
    }
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
