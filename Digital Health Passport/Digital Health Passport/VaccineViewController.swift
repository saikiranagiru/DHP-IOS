//
//  VaccineViewController.swift
//  Digital Health Passport
//
//  Created by student on 5/17/22.
//

import UIKit

class VaccineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Vaccinelist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "vaccineCell", for: indexPath)
              //Assign the data to the cell.
        cell.textLabel?.text = Vaccinelist[indexPath.row].info?.report           //return cell
              return cell
    }
    
    
    @IBAction func onRefresh(_ sender: UIButton) {
        self.tableview.reloadData()
 //       postData()
    }
    var user: User? = nil
    var token: String = ""
//    
    
    @IBOutlet weak var tableview: UITableView!
    var Vaccinelist: [Transaction] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
//    func postData() {
//        let userid = user?._id ?? ""
//        let reqURL = "https://dhp-server.herokuapp.com/api/holder/search/all/\(userid)"
//        print(reqURL)
//        // 1) create URL
//        guard let url = URL(string:reqURL) else { fatalError("error with URL ")}
//        // 2) create request
//        var httpRequest = URLRequest(url: url)
//        httpRequest.httpMethod = "GET"
//        httpRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//        // 3) create data task with closures
//        let dataTask = URLSession.shared.dataTask(with: httpRequest) {( data, response, Error) in
//
//            // 3.1) null check
//            guard let data = data else {return }
//
//            // 3.2) parsing the JSON to struct
//            do {
//                let decoded = try JSONDecoder().decode([Transaction].self, from: data);
//                DispatchQueue.main.async {
//
//                    self.Vaccinelist = decoded
//                    self.tableview.reloadData()
//                }
//
//            } catch let error {
//                print("Error in JSON parsing", error)
//            }
//        }
//        // 4) make an API call
//        dataTask.resume()
//    }
//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let transition = segue.identifier
        if transition == "vaacinereportSegue" {
            let destination = segue.destination as! ReportViewController
            destination.user = user
            destination.token = token
            destination.tx = Vaccinelist[(tableview.indexPathForSelectedRow?.row)!]
        }
        
    }

    


}
