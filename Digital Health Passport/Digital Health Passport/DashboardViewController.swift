//
//  DashboardViewController.swift
//  Digital Health Passport
//
//  Created by student on 3/29/22.
//

import UIKit
import Foundation


struct Transaction: Codable {
    let _id, transaction_id, issuer_id, holder_id: String?
    let createdAt, updatedAt: String?
    let __v: Int?
    var info: Info?
}

struct Info: Codable {
    let reportType, name, report, by, fullname, serviceType, serviceName, contact, eligibleToFly: String?

}

class DashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return txs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewOutlet.dequeueReusableCell(withIdentifier: "reportCell", for: indexPath)
              //Assign the data to the cell.
        cell.textLabel?.text = txs[indexPath.row].info?.report           //return cell
              return cell
    }
    
    @IBAction func onRefresh(_ sender: UIButton) {
        postData()
    }
    @IBOutlet weak var dhplbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        postData()
        namelbl.text = "Hello, " + user!.first_name + " " + user!.last_name
        dhplbl.text = "My DHP Id : " + user!.dhp_id
        // Do any additional setup after loading the view.
    }
    
    var user: User? = nil
    var token: String = ""
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var txs: [Transaction] = []
    

    @IBOutlet weak var namelbl: UILabel!
    
    func postData() {
        let userid = user?._id ?? ""
        let reqURL = "https://dhp-server.herokuapp.com/api/holder/search/all/\(userid)"
        print(reqURL)
        // 1) create URL
        guard let url = URL(string:reqURL) else { fatalError("error with URL ")}
        // 2) create request
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "GET"
        httpRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
       
        // 3) create data task with closures
        let dataTask = URLSession.shared.dataTask(with: httpRequest) {( data, response, Error) in
            
            // 3.1) null check
            guard let data = data else {return }
         
            // 3.2) parsing the JSON to struct
            do {
                let decoded = try JSONDecoder().decode([Transaction].self, from: data);
                DispatchQueue.main.async {
                    self.txs = decoded
                    self.tableViewOutlet.reloadData()
                }
               
            } catch let error {
                print("Error in JSON parsing", error)
            }
        }
        // 4) make an API call
        dataTask.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let transition = segue.identifier
        if transition == "eachReportSegue" {
            let destination = segue.destination as! ReportViewController
            destination.user = user
            destination.token = token
            destination.tx = txs[(tableViewOutlet.indexPathForSelectedRow?.row)!]
        }
    }

}
