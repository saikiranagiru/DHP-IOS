//
//  ProfileViewController.swift
//  Digital Health Passport
//
//  Created by Sai Kiran on 5/19/22.
//

import UIKit
import Foundation

struct UpdatePasswordResponse: Codable {
    let status: String?
}

class ProfileViewController: UIViewController {
    
    var user: User? = nil
    var token: String = ""

    @IBOutlet weak var lbl1: UILabel!
    
    @IBOutlet weak var lbl2: UILabel!
    
    @IBOutlet weak var lbl3: UILabel!
    
    @IBOutlet weak var newpassword: UITextField!
    @IBOutlet weak var Onclickupdate: UIButton!
    @IBOutlet weak var lbl4: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        lbl1.text = "First Name : " + user!.first_name
        lbl2.text = "Last Name : " + user!.last_name
        lbl3.text = "Email : " + user!.email
        lbl4.text = "DHP ID : " + user!.dhp_id

    }
    
    
    var new = ""
    @IBAction func onclickUpdate(_ sender: UIButton) {
        postData();
        
    }
    
    func postData() {
        
  

        let userid = user?._id ?? ""
        let reqURL = "https://dhp-server.herokuapp.com/api/auth/updatepassword/\(userid)"
        print(reqURL)
        // 1) create URL
        guard let url = URL(string:reqURL) else { fatalError("error with URL ")}
        // 2) create request
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "POST"
        httpRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        var updatedPassword = newpassword.text!;
        let parameters: [String: Any] = ["password": updatedPassword]
        httpRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        // 3) create data task with closures
        let dataTask = URLSession.shared.dataTask(with: httpRequest) {( data, response, Error) in
            
            // 3.1) null check
            guard let data = data else {return }
         
            // 3.2) parsing the JSON to struct
            print(data)
            do {
                let decoded = try JSONDecoder().decode(UpdatePasswordResponse.self, from: data);
                DispatchQueue.main.async {
                    
//                    self.txs = decoded
//                    self.identify()
//                    self.tableViewOutlet.reloadData()
//                    self.Refresh.isEnabled = true
                    self.displayLoginAlert();
                }
               
            } catch let error {
                print("Error in JSON parsing", error)
            }
        }
        // 4) make an API call
        dataTask.resume()
    }
    
    func displayLoginAlert() {

        let alert = UIAlertController(title:"Password Changed Successfully",
                                      message:"",
                                      preferredStyle: UIAlertController.Style.alert)

        let passwordAction = UIAlertAction(title:"Ok",
                                           style:UIAlertAction.Style.default) { [self] (UIAlertAction) -> Void in
            newpassword.text = ""
        }

        alert.addAction(passwordAction)

        self.present(alert, animated: true)
    }
    
}


