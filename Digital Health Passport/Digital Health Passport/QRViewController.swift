//
//  QRViewController.swift
//  Digital Health Passport
//
//  Created by Konduri,Sai Deep on 4/23/22.
//

import UIKit

class QRViewController: UIViewController {
    var txId: String? = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let myString = txId
        {
        let data = myString.data(using: .ascii, allowLossyConversion: false)
        let filter = CIFilter (name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "InputMessage")
        let cilmage = filter?.outputImage
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let transformImage = cilmage?.transformed(by: transform)
            let im = UIImage(ciImage: transformImage!)
            image.image = im
        }
        // Do any additional setup after loading the view.
    }
    
   


    @IBOutlet weak var image: UIImageView!
    
}
