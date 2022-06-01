//
//  DashboardViewController.swift
//  Digital Health Passport
//
//  Created by student on 3/29/22.
//

import UIKit
import Foundation


struct Transaction: Codable {
    let _id, transaction_id, issuer_id, holder_id, serviceType: String?
    let createdAt, updatedAt: String?
    let __v: Int?
    var info: Info?

}

struct Info: Codable {
    let reportType, name, report, by, fullname, serviceType, serviceName, contact, eligibleToFly: String?

}

//struct Testlist{
//
//}
//
//struct Vaccinelist{
//
//}



class DashboardViewController: UIViewController {
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//       return txs.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableViewOutlet.dequeueReusableCell(withIdentifier: "reportCell", for: indexPath)
//              //Assign the data to the cell.
//        cell.textLabel?.text = txs[indexPath.row].info?.report           //return cell
//              return cell
//    }
    
    @IBOutlet weak var Refresh: UIButton!
    @IBAction func onRefresh(_ sender: UIButton) {
        testlist = []
        vaccinelist = []
        txs = []
        postData()
    }
    @IBOutlet weak var dhplbl: UILabel!
    
    @IBAction func Profile(_ sender: UIBarButtonItem) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableViewOutlet.delegate = self
//        tableViewOutlet.dataSource = self
        postData()
        
        //dhplbl.text = user!.dhp_id
        
        let attrString = NSAttributedString(
            string: user!.dhp_id,
            attributes: [
                NSAttributedString.Key.strokeColor: UIColor.black,
                NSAttributedString.Key.foregroundColor: UIColor.systemTeal,
                NSAttributedString.Key.strokeWidth: -0.5,
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25.0)
            ]
        )
        dhplbl.attributedText = attrString
        
        // Do any additional setup after loading the view.
    }
    
    
    var user: User? = nil
    var token: String = ""
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var txs: [Transaction] = []
    
    var testlist: [Transaction] = []
    
    var vaccinelist: [Transaction] = []

    
    
    func postData() {
        
        txs = []
        Refresh.isEnabled = false
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
                    self.identify()
//                    self.tableViewOutlet.reloadData()
                    self.Refresh.isEnabled = true
                }
               
            } catch let error {
                print("Error in JSON parsing", error)
            }
        }
        // 4) make an API call
        dataTask.resume()
    }
    
    func identify(){
        for val in txs{
            if (val.info?.serviceType == "test"){
                testlist.append(val)
            }
            else{
                vaccinelist.append(val)
            }
            }
        }


//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let transition = segue.identifier
//        if transition == "eachReportSegue" {
//            let destination = segue.destination as! ReportViewController
//            destination.user = user
//            destination.token = token
//            destination.tx = txs[(tableViewOutlet.indexPathForSelectedRow?.row)!]
//        }
//    }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let transition = segue.identifier
            if transition == "testSegue" {
                let destination = segue.destination as! TestViewController
                destination.Testlist = []
                destination.Testlist = testlist
                destination.user = user
                destination.token = token
//                destination.tx = txs[(tableViewOutlet.indexPathForSelectedRow?.row)!]
            }
            
            if transition == "vaccineSegue" {
                            let destination = segue.destination as! VaccineViewController
                            
                            destination.Vaccinelist = vaccinelist
                            destination.user = user
                            destination.token = token
            //                destination.tx = txs[(tableViewOutlet.indexPathForSelectedRow?.row)!]
                        }
            
            if transition == "profileSegue" {
                let destination = segue.destination as! ProfileViewController
                destination.user = user
                destination.token = token
            }
        }
    
}
