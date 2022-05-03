//
//  ViewController.swift
//  Digital Health Passport
//
//  Created by student on 3/25/22.
//

import UIKit
import ArgumentParser

struct User: Codable {
    let _id: String
    let first_name, last_name, email, role, dhp_id : String
   
}


struct LoginResponse: Codable {
    let token: String
    let user: User

}



class LoginViewController: UIViewController {
    
    @IBAction func onLogin(_ sender: UIButton) {
        let email = DHPID.text!
        let password = DHPPassword.text!
        if (email == "" || password == "") {
            return
        }
        LoginButton.isEnabled = false
        postData()
    }
    @IBOutlet weak var DHPID: UITextField!
    
    @IBOutlet weak var DHPPassword: UITextField!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    
    var authToken: String = ""
    var user: User? = nil
    
   
    override func viewDidLoad() {
            super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if authToken != "" {
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    
    
    func postData() {
        spinner.startAnimating()
        // 1) create URL
        guard let url = URL(string:"https://dhp-server.herokuapp.com/api/auth/signin") else { fatalError("error with URL ")}
        // 2) create request
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "POST"
        let email = DHPID.text!
        let password = DHPPassword.text!
        let parameters: [String: Any] = ["email": email, "password": password]
       
        httpRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
       
        // 3) create data task with closures
        let dataTask = URLSession.shared.dataTask(with: httpRequest) {( data, response, Error) in
            
            // 3.1) null check
            guard let data = data else {return }
         
            // 3.2) parsing the JSON to struct
            
            do {
                let decoded = try JSONDecoder().decode(LoginResponse.self, from: data);
                DispatchQueue.main.async {
                    self.user = decoded.user
                    self.authToken = decoded.token
                    print("Successfully logged in")
                  //  let loader =   self.loader()
                    self.stopSpinning();
                    self.LoginButton.isEnabled = true
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                    
                }
               
            } catch let error {
                print("Error in JSON parsing", error)
                self.stopSpinning();
                self.LoginButton.isEnabled = true
                
            }
        }
        // 4) make an API call
        dataTask.resume()
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "loginSegue" {
            if authToken != "" {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
        
       
           
    }

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    func stopSpinning() {
        spinner.stopAnimating();
        spinner.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           let transition = segue.identifier
           
           //We need to view courses of the logged in student in CourseViewController,
           // So we pass the courses from the 'studentObj' variable
           if transition == "loginSegue" {
               let destination = segue.destination as! DashboardViewController
               
               //we will assign the courses to 'courseArray' in the CourseViewController
               destination.user = user
               destination.token = authToken
           }
       }
    
}
