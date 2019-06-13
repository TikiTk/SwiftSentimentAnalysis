//
//  ViewController.swift
//  Hello World!
//
//  Created by Emmett Brown on 2019/05/28.
//  Copyright © 2019 empty. All rights reserved.
//

import UIKit
import CoreData
import LocalAuthentication
import TrustKit


class ViewController: UIViewController,URLSessionDelegate {
    //MARK: Properties

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameResults: UILabel!
    @IBOutlet weak var btnProcess: UIButton!
    @IBOutlet weak var btnViewResults: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    
        
        //Retrieving last loaded data
        
        
        //UserDefaults.standard.set(date, forKey:"date")

       jailDetection()
        
       
       
        var text =  UserDefaults.standard.string(forKey:"text")
        var polarity =  UserDefaults.standard.string(forKey:"polarity")
        var subjectivity = UserDefaults.standard.string(forKey:"subjectivity")
        var polarityConf =  UserDefaults.standard.double(forKey:"polarityConf")
        var subjectivityConf = UserDefaults.standard.double(forKey:"subjectivityConf")
        if subjectivityConf == nil || polarityConf == nil || text == nil || polarity == nil || subjectivity == nil {
            subjectivityConf = 0.0
            polarityConf = 0.0
            text = ""
            subjectivity = ""
            polarity = ""
        }
        
        let strPolarityConf:String = String(format: "%.3f", polarityConf)
        let strSubjectConf:String = String(format:"%.3f",subjectivityConf)
        var result = "Text: "+text!+"\nPorality: "+polarity!+"\nSubjectivity: "
        var temp = subjectivity!+"\nPolarityConf. : "+strPolarityConf+"\nSubjectivityConf. : "+strPolarityConf
        let final = result + temp
        
        nameResults.text = "Last request:\n\n" + final
    }
  

    
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        // Call into TrustKit here to do pinning validation
        if TrustKit.sharedInstance().pinningValidator.handle(challenge, completionHandler: completionHandler) == false {
            print("Insecure communication")
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
    lazy var session: URLSession = {
        URLSession(configuration: URLSessionConfiguration.ephemeral,
                   delegate: self,
                   delegateQueue: OperationQueue.main)
    }()
    
    
    //MARK: Actions
    @IBAction func nameProcess(_ sender: UIButton) {
       
    }
    
    @IBAction func ViewResults(_ sender: Any) {
        
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
    
    @IBAction func onGo(_ sender: Any) {
        if(nameTextField.returnKeyType == UIReturnKeyType.go){
            makeRequest()
        }
    }
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        //alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    

    fileprivate func makeRequest() {
        
        
        let getURL = URL(string: "https://aylien-text.p.rapidapi.com/sentiment?text="+(nameTextField.text?.addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!)!)!
        
        var getRequest = URLRequest(url: getURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        getRequest.httpMethod = "GET"
        getRequest.setValue("55fe9e8845msh951c486382b46ffp12db9ajsn140970b1b7db", forHTTPHeaderField: "X-RapidAPI-Key")
        getRequest.setValue("aylien-text.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        getRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.addSubview(activityIndicator) // add it as a  subview
        activityIndicator.center = CGPoint(x: view.frame.size.width*0.5, y: view.frame.size.height*0.5) // put in the middle
        activityIndicator.startAnimating()
        
        URLSession.shared.dataTask(with: getRequest, completionHandler: { (data, response, error) -> Void in
            if error != nil { print("GET Request: Communication error: \(error!)") }
            if data != nil {
                do {
                    let resultObject = try JSONSerialization.jsonObject(with: data!, options: [] )
                    DispatchQueue.main.async(execute: {
                        activityIndicator.stopAnimating()
                        activityIndicator.removeFromSuperview()
                        print("Results from GET https://httpbin.org/get?bar=\(String(describing: self.nameTextField.text)) :\n\(resultObject)")
                        
                        if let dictionary = resultObject as? [String: Any] {
                            
                            let polarity = dictionary["polarity"] as? String
                            let subjectivity = dictionary["subjectivity"] as? String
                            let polarity_confidence = dictionary["polarity_confidence"] as? Double
                            let subjectivity_confidence = dictionary["subjectivity_confidence"] as? Double
                            let text = dictionary["text"] as? String
                            let strPolarityConf:String = String(format: "%.3f", polarity_confidence!)
                            let strSubjectConf:String = String(format:"%.3f",subjectivity_confidence!)
                            let result = "Porality: "+polarity!+"\nSubjectivity: "+subjectivity!+"\nPolarityConf. : "+strPolarityConf+"\nSubjectivityConf. : "+strSubjectConf
                            self.nameResults.text = result
                            
                            self.storeData(date: Date(),text: text!,polarity: polarity!,polarityConf: polarity_confidence!,subjectivity: subjectivity!,subjectivityConf: subjectivity_confidence!)
                        }
                        
                    })
                } catch {
                    DispatchQueue.main.async(execute: {
                        print("Unable to parse JSON response")
                    })
                }
            } else {
                DispatchQueue.main.async(execute: {
                    print("Received empty response.")
                })
            }
        }).resume()
    }
    
    @IBAction func ProcessTask(_ sender: Any) {
        makeRequest()
        
}
    func storeData(date: Date, text: String, polarity: String, polarityConf : Double, subjectivity : String, subjectivityConf: Double){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName:"SentimentAnalysisStoredResults", in: context)
        let newEntry = NSManagedObject(entity: entity!, insertInto: context)
        newEntry.setValue(date, forKey:"date")
        newEntry.setValue(polarity, forKey:"polarity")
        newEntry.setValue(polarityConf, forKey:"polarityConf")
        newEntry.setValue(subjectivity,forKey:"subjectivity")
        newEntry.setValue(subjectivityConf,forKey:"subjectivityConf")
        newEntry.setValue(text,forKey:"text")
        
       // UserDefaults.standard.set(date, forKey:"date")
     
        
        do {
            try context.save()
            UserDefaults.standard.set(polarity, forKey:"polarity")
            UserDefaults.standard.set(polarityConf, forKey:"polarityConf")
            UserDefaults.standard.set(subjectivity,forKey:"subjectivity")
            UserDefaults.standard.set(subjectivityConf,forKey:"subjectivityConf")
            UserDefaults.standard.set(text,forKey:"text")
        } catch {
            print("Failed saving")
        }
        
    }
    
    
}

