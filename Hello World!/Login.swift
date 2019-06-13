//
//  Login.swift
//  Hello World!
//
//  Created by Marty McFly on 2019/05/31.
//  Copyright © 2019 empty. All rights reserved.
//

import UIKit
import LocalAuthentication
class Login: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //jailDetection()

        // Do any additional setup after loading the view.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showErrorMessageForLAErrorCode( errorCode:Int ) -> String{
        
        var message = ""
        
        switch errorCode {
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.biometryLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.biometryNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
            
        }
        
        return message
        
    }
    
    @IBAction func Authenticate(_ sender: Any) {
        
       // jailDetection()
        authenticateUserTouchID()
        
    }
    func authenticateUserTouchID(){
        let context = LAContext()
        var error: NSError?
   
        
        // 2
        // check if Touch ID is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // 3
            let reason = "Authenticate with Touch ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply:
                {(success, error) in
                    // 4
                    if success {
                       DispatchQueue.main.async {
                            self.showAlertController("Touch ID Authentication Succeeded")
                        
                       }
                        self.performSegue(withIdentifier: "send", sender: self)
                        
                    }
                    else {
                        self.showAlertController("Touch ID Authentication Failed")
                    }
            })
        }
            // 5
        else {
            showAlertController("Touch ID not available")
        }
       
    }
    func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true, completion: nil)
    
    }
    
    func jailDetection(){
        if TARGET_IPHONE_SIMULATOR != 1{
            if FileManager.default.fileExists(atPath: "Applications/Cydia.app") || FileManager.default.fileExists(atPath: "/Library/MobileSubtrate/MobileSubstrate.dylib") ||  FileManager.default.fileExists(atPath: "/bin/bash")
                || FileManager.default.fileExists(atPath: "/usr/sbin/sshd")
                || FileManager.default.fileExists(atPath: "/etc/apt")
                || FileManager.default.fileExists(atPath: "/private/var/lib/apt/")
                || UIApplication.shared.canOpenURL(URL(string:"cydia://package/com.example.package")!) { self.showAlertController("Device is jailbroken")}
        }
        let stringToWrite = "Jailbreak Test"
        do
        {
            try stringToWrite.write(toFile:"/private/JailbreakTest.txt", atomically:true, encoding:String.Encoding.utf8)
            showAlertController("Device is jailbroken")
        }catch{
            return
        }
        
        
    }
        
    }


