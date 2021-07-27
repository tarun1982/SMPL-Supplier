//
//  ViewTableViewController.swift
//  SMPL Supplier
//
//  Created by Family on 11/11/20.
//  Copyright © 2020 Family. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import MobileCoreServices
import WebKit


class ViewTableViewController: UIViewController, URLSessionDelegate, WKNavigationDelegate  {

    var webview: WKWebView!
    @IBOutlet weak var tableV: UITableView!
    var pdfURL: URL!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
               // Always adopt a light interface style.
               overrideUserInterfaceStyle = .light
           }
        FetchDetails()
        tableV.rowHeight = UITableView.automaticDimension
        tableV.estimatedRowHeight = 70
        // Do any additional setup after loading the view.
    }
    
     func FetchDetails() {
        self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.2))

        guard let supp = KeychainWrapper.standard.string(forKey: "supplierID") else { return }
           let header:HTTPHeaders = [
               "X-API-KEY": Constants.XAPIKey
           ]
           
           AF.request(Constants.viewapi + supp, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: header).authenticate(username: "admin", password: "1234").responseJSON{ response in
               switch response.result {
               case .success:
                   print("result:- \(response.result)")
                   let myresult = try? JSON(data: response.data!)
                   let resultArray = myresult!["data"]
                   for i in resultArray.arrayValue {
                    let date = i["date"].stringValue
                    ViewSaved.date.append(date)
                    let id = i["id"].stringValue
                    ViewSaved.id.append(id)
                    let inovice_file = i["invoice_file"].stringValue
                    ViewSaved.invoicefile.append(inovice_file)
                    let invoicenum = i["invoice_num"].stringValue
                    ViewSaved.invoicenum.append(invoicenum)
                    let totalqty = i["total_qty"].stringValue
                    ViewSaved.totalqty.append(totalqty)
                    let totalamount = i["total_amount"].stringValue
                    ViewSaved.totalamount.append(totalamount)
                   }
                   self.tableV.reloadData()
                   self.view.activityStopAnimating()

                   break
               case .failure:
                   print(response.debugDescription)
               }
           }
       }

}

extension ViewTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewSaved.date.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableV.dequeueReusableCell(withIdentifier: "view") as! ViewTableViewCell
        cell.date.text = ViewSaved.date[indexPath.row]
        cell.inovicenum.text = ViewSaved.invoicenum[indexPath.row]
        cell.totalqty.text = ViewSaved.totalqty[indexPath.row]
        cell.Totalamount.text = ViewSaved.totalamount[indexPath.row]
        cell.downloadBtn.addTarget(self, action: #selector(download), for:  .touchUpInside)
        cell.downloadBtn.tag = indexPath.row
    return cell
    }
    
    @objc func download(_ sender: UIButton){
        let seturl = ViewSaved.invoicefile[sender.tag]
        let url = URL(string: "http://sparklemanufacturing.com/api/" + seturl)
        FileDownloader.loadFileAsync(url: url!) { (path, error) in
            print("PDF File downloaded to : \(path!)")
        }
        let alert = UIAlertController(title: "", message: "Invoice Downloaded", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
         
            self.webview = WKWebView()
            self.webview.navigationDelegate = self
            self.view = self.webview
//            view = self.webview
            let url = URL(string: "http://sparklemanufacturing.com/api/" + seturl)!
            self.webview.load(URLRequest(url: url))
            self.webview.allowsBackForwardNavigationGestures = true
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
}

extension ViewTableViewController:  URLSessionDownloadDelegate {
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
            self.pdfURL = destinationURL
           
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Downloaded", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action
                    in
                    let pdfViewController = PDFViewController()
                                   pdfViewController.pdfURL = self.pdfURL
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
