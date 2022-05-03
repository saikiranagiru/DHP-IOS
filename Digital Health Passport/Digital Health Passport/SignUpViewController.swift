//
//  SignUpViewController.swift
//  Digital Health Passport
//
//  Created by student on 4/3/22.
//

import UIKit
import Foundation

struct SignupResponse: Codable {
    let dhp_id, first_name, last_name, middle_name: String
    let phone_number, verification_id, verification_type, verification_issued_country: String?
    let verification_issued_date, gender: String?
    let terms_condition: Bool
    let email, role: String
    let active: Bool?
    let _id, createdAt: String
    let __v: Int
}

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var firstname: UITextField!
    
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var emailaddress: UITextField!
    
    @IBOutlet weak var idnumber: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    

    @IBOutlet weak var expiry: UITextField!
    
    
    @IBOutlet weak var confirmpassword: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var dhp_id: String = ""
    
    
    @IBAction func onSignup(_ sender: UIButton) {
        sender.isEnabled = false;
        postData();
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func postData() {
        // 1) create URL
        guard let url = URL(string:"https://dhp-server.herokuapp.com/api/auth/signup") else { fatalError("error with URL ")}
        // 2) create request
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "POST"
        let email = emailaddress.text!
        let firstname = firstname.text!
        let lastname = lastname.text!
        let password = password.text!
        let dob = dob.text!
        let exipry = expiry.text!
        let idnumber = idnumber.text!
        let phone = phone.text!
        
        
        

        let parameters: [String: Any] = ["email": email,"password": password,"first_name":firstname,"last_name":lastname,"middle_name":"","gender":"MALE","role":"HOLDER","phone_number":phone,"verification_id":idnumber,"verification_type":"DRIVERS LICENSE","terms_condition": true]
        
        httpRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
       
        // 3) create data task with closures
        let dataTask = URLSession.shared.dataTask(with: httpRequest) {( data, response, Error) in
            
            // 3.1) null check
            guard let data = data else {return }
         
            // 3.2) parsing the JSON to struct
            do {
                let decoded = try JSONDecoder().decode(SignupResponse.self, from: data);
                DispatchQueue.main.async {
                    self.dhp_id = decoded.dhp_id;
                    if (self.dhp_id != "") {
                        self.performSegue(withIdentifier: "signupToLoginSegue", sender: self)
                    }
                    
                }
                print(decoded)
               
            } catch let error {
                print("Error in JSON parsing", error)
            }
        }
        // 4) make an API call
        dataTask.resume()
    }
    
    
    


    //
}
