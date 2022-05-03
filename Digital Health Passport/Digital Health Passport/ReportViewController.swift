//
//  ReportViewController.swift
//  Digital Health Passport
//
//  Created by Konduri,Sai Deep on 4/23/22.
//

import UIKit
import PDFKit

import WebKit

struct FileResponse: Codable {
var url: String?
}


class ReportViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        reportName.text = tx?.info?.report
        postData()
    }
    
    @IBOutlet weak var reportName: UILabel!
    
    
    @IBAction func onShare(_ sender: UIButton) {
        self.performSegue(withIdentifier: "displayQRSegue", sender: self)
    }
    
    var user: User? = nil
    var token: String = ""
    var tx: Transaction? = nil
    
    @IBOutlet weak var web: WKWebView!
    func postData() {
        let userid = user?._id ?? ""
        let txId = tx?.transaction_id ?? ""
        let reqURL = "https:dhp-server.herokuapp.com/api/holder/mtransaction/\(txId)/\(userid)"
        print(reqURL)
        guard let url = URL(string:reqURL) else { fatalError("error with URL ")}
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "GET"
        httpRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let dataTask = URLSession.shared.dataTask(with: httpRequest) {( data, response, Error) in
            
            // 3.1) null check
            guard let data = data else {return }
         
            // 3.2) parsing the JSON to struct
            do {
                let decoded = try JSONDecoder().decode(FileResponse.self, from: data);
                DispatchQueue.main.async {
                    self.loadPDF(rquesturl: decoded.url!)
                }
               
            } catch let error {
                print("Error in JSON parsing", error)
            }
        }
        // 4) make an API call
        dataTask.resume()
        
        
        
 
    }
    
    func loadPDF(rquesturl: String) {
        print(rquesturl)
        if let url =  URL(string: rquesturl) {
            web?.load(URLRequest(url: url))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           let transition = segue.identifier
           
           //We need to view courses of the logged in student in CourseViewController,
           // So we pass the courses from the 'studentObj' variable
           if transition == "displayQRSegue" {
               let destination = segue.destination as! QRViewController
               
               //we will assign the courses to 'courseArray' in the CourseViewController
               destination.txId = tx?.transaction_id ?? ""
           }
       }

}
