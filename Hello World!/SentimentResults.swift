//
//  SentimentResults.swift
//  Hello World!
//
//  Created by Marty McFly on 2019/05/30.
//  Copyright © 2019 empty. All rights reserved.
//

import UIKit
import CoreData



var resultsContents: [String] = []
var resultsTitle: [String] = []
var resultsDate: [String] = []

class SentimentResults: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        jailDetection()
        returnValues()
        
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print(Array(Set(resultsDate)))
        return Array(Set(resultsDate)).count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(resultsContents)
        return resultsTitle.count
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
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        //alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func returnValues(){
        jailDetection()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"SentimentAnalysisStoredResults")
        request.returnsObjectsAsFaults = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let results = try context.fetch(request)
            for data in results as! [NSManagedObject]{
                let text = (data.value(forKey:"text") as! String)
                let polarity = (data.value(forKey:"polarity") as! String)
                let polarityConf = (data.value(forKey:"polarityConf") as! Double)
                let subjectivity = (data.value(forKey:"subjectivity") as! String)
                let subjectivityConf = (data.value(forKey:"subjectivityConf") as! Double)
                
                var date = (data.value(forKey:"date") as! Date)
                
                let format = DateFormatter()
                format.dateFormat = "dd-MM-yyyy"
                let formattedDate = format.string(from: date)
            
        
                
                let strPolarityConf:String = String(format: "%.3f", polarityConf)
                let strSubjectivityConf:String = String(format:"%.3f",subjectivityConf)
                
                var result = "Porality: "+polarity+"\nSubjectivity: "+subjectivity+"\nPolarityConf. : "+strPolarityConf+"\nSubjectivityConf. : "
                result = result + strSubjectivityConf
                print(result)
                if !resultsContents.contains(result) && !resultsDate.contains(formattedDate) {
                    resultsContents.append(result)
                    resultsTitle.append(text)
                    resultsDate.append(formattedDate)
                    
                }
                
                
                
            }
        } catch {
            print("Failed")
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.text = resultsTitle[indexPath.row]
        cell.detailTextLabel?.text = resultsContents[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section:Int) -> String? {
        return "Date \(Array(Set(resultsDate))[section])"
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
