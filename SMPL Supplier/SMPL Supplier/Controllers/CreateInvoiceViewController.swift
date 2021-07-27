//
//  CreateInvoiceViewController.swift
//  SMPL Supplier
//
//  Created by Family on 06/11/20.
//  Copyright © 2020 Family. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class CreateInvoiceViewController: BaseViewController {

    @IBOutlet weak var invoice:UITextField!
    @IBOutlet weak var ewaybil:UITextField!
    @IBOutlet weak var transporter:UITextField!
    @IBOutlet weak var vehicle:UITextField!
    @IBOutlet weak var grno:UITextField!
    
    func CreateInvoce(supplierid:String, invocenum:String, ewaybill:String, transporter:String, vehicleno:String, grno:String, totalqty: Int, totalamount:Int, gst: Float) {
        self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.2))
        let header:HTTPHeaders = [
                   "X-API-KEY": Constants.XAPIKey
               ]
        let parameters = [
            "supplier_id": supplierid,
            "item_id": models.savedItems,
            "rate": models.savedRates,
            "quantity": models.savedQTY,
            "amount": models.savedAmount,
            "invoice_num": invocenum,
            "eway_bill": ewaybill,
            "transporter": transporter,
            "vehicle_no": vehicleno,
            "gst": gst,
            "gr_no": grno,
            "total_qty": totalqty,
            "total_amount": totalamount
            ] as [String : Any]
               print("params:- \(parameters)")
               AF.request(Constants.BaseURL+Constants.createInvoce, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: header).authenticate(username: "admin", password: "1234").responseJSON{ response in
                   switch response.result {
                   case .success:
                      print("result:- \(response.result)")
                    self.view.activityStopAnimating()
                       let myresult = try? JSON(data: response.data!)
                       let resultArray = myresult!["message"].stringValue
                      let data = myresult!["data"].stringValue
                      let url = URL(string: "http://sparklemanufacturing.com/api/invoice-view/\(data)") //Or your URL
                                             var request = URLRequest(url: url!)
                                             request.httpMethod = "GET"
                                             request.httpBody = "".data(using: .utf8)!

                                             let task = URLSession.shared.dataTask(with: request) { data, response, error in
                                                 if error != nil {
                                                     //There was an error
                                                 } else {
                                                     //The HTTP request was successful
                                                     //print("rdju:- \(String(data: data!, encoding: .utf8)!)")
                                                    // print(String(data: data!, encoding: .utf8)!)
                                                 }

                                             }
                                             task.resume()
                       let alert = UIAlertController(title: "Alert", message: resultArray, preferredStyle: .alert)
                       alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        vc.modalPresentationStyle = .fullScreen
                        self.navigationController?.pushViewController(vc, animated: true)
                       }))
                       self.present(alert, animated: true, completion: nil)
                       break
                   case .failure:
                       print(response.debugDescription)
                   }
               }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func generateInvoice(_ sender: Any){
        models.savedRates = models.savedRates.filter {$0 != "0"}
        models.savedItems = models.savedItems.filter {$0 != "0"}
        models.savedAmount = models.savedAmount.filter {$0 != "0"}
        models.savedQTY = models.savedQTY.filter {$0 != "0"}
        
        let intQTYArray = models.savedQTY.map { Int($0)!}
        let intAmountArray = models.savedAmount.map { Int($0)!}
        let sumOfQTY = intQTYArray.reduce(0, +)
        let sumOfAmount = intAmountArray.reduce(0, +)
        print(sumOfQTY)
        print(sumOfAmount)
        print(models.savedItems)
        let gstconvert:Float = Float(sumOfAmount * 18 / 100)
        if validate() {
            guard let supp = KeychainWrapper.standard.string(forKey: "supplierID") else { return  }
            CreateInvoce(supplierid: supp, invocenum: self.invoice.text ?? "", ewaybill: self.ewaybil.text ?? "", transporter: self.transporter.text ?? "", vehicleno: self.vehicle.text ?? "", grno: self.grno.text ?? "", totalqty: sumOfQTY, totalamount: sumOfAmount, gst: gstconvert)
        }
    }
    
    func validate() -> Bool {
        guard self.ewaybil.text!.count > 0 else {
            self.show(alertWithTitle: "Supplier Alert",
                      message: "Please Enter EwayBill")
            return false
        }
        guard self.grno.text!.count > 0 else {
            self.show(alertWithTitle: "Supplier Alert",
                      message: "Please Enter GR Number")
            return false
        }
        
        guard self.invoice.text!.count > 0 else {
            self.show(alertWithTitle: "Supplier Alert",
                      message: "Please Enter Invoice")
            return false
        }
        
        guard self.transporter.text!.count > 0 else {
            self.show(alertWithTitle: "Supplier Alert",
                      message: "Please Enter Transporter")
            return false
        }
        guard self.vehicle.text!.count > 0 else {
            self.show(alertWithTitle: "Supplier Alert",
                      message: "Please Enter Vehicle Number")
            return false
        }
        
        return true
    }
    
}

extension CreateInvoiceViewController:  URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
        
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
           // self.pdfURL = destinationURL
           
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Downloaded", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action
                    in
                    let pdfViewController = PDFViewController()
                                  // pdfViewController.pdfURL = self.pdfURL
                                   pdfViewController.modalPresentationStyle = .fullScreen
                                   self.navigationController?.pushViewController(pdfViewController, animated: true)
                }))
                           self.present(alert, animated: true, completion: nil)
               
                      }
                           
           
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}
