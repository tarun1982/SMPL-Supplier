//
//  HomeViewController.swift
//  SMPL Supplier
//
//  Created by Family on 04/11/20.
//  Copyright © 2020 Family. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import WebKit

class HomeViewController: BaseViewController, WKNavigationDelegate {
    
    @IBOutlet weak var createinvoiceView: UIView!
    @IBOutlet weak var viewinvoiceView: UIView!
    @IBOutlet weak var createInvoiceTitle: UILabel!
    @IBOutlet weak var viewInvoiceTitle: UILabel!
    @IBOutlet weak var table: UITableView!
    
    var webview: WKWebView!
    var temp = Int()
    var str = String()
    var savedstates = [Int]()
    var savedQty = [String]()
    var changeQty = [String]()
    var selectedstarplayer1 = [Int]()
    private var section: Int = 0
    private var item: Int = 0
    var UniversalText = String()
    //MARK:- Customize NavBar
    fileprivate func CustomizeNavBar() {
        self.navigationItem.title = ""
        self.navigationItem.setHidesBackButton(true, animated: true)

    }

    //MARK:- Customize View
    fileprivate func CustomizeView() {
        self.createinvoiceView.backgroundColor = .white
        self.createInvoiceTitle.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        self.viewInvoiceTitle.textColor = .white
        self.viewinvoiceView.backgroundColor = .clear
        self.viewinvoiceView.layer.borderWidth = 1
        self.viewinvoiceView.layer.borderColor = UIColor.white.cgColor
        self.viewinvoiceView.layer.cornerRadius = 7
        self.createinvoiceView.layer.cornerRadius = 7
    }
    
   // MARK:- Customize ViewInoice
    fileprivate func CustomizeViewInvoceView() {
        self.createinvoiceView.backgroundColor = .clear
        self.createinvoiceView.layer.borderColor = UIColor.white.cgColor
        self.createinvoiceView.layer.borderWidth = 1
        self.viewinvoiceView.backgroundColor = .white
        self.viewInvoiceTitle.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        self.createInvoiceTitle.textColor = .white
    }
    
    func FetchDetails() {
        self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.2))
        let header:HTTPHeaders = [
            "X-API-KEY": Constants.XAPIKey
        ]
        
        AF.request(Constants.BaseURL+Constants.material, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: header).authenticate(username: "admin", password: "1234").responseJSON{ response in
            switch response.result {
            case .success:
               // print("result:- \(response.result)")
                let myresult = try? JSON(data: response.data!)
                let resultArray = myresult!["data"]
                models.id.removeAll()
                models.name.removeAll()
                models.rate.removeAll()
                models.savedQTY.removeAll()
                models.savedAmount.removeAll()
                models.savedItems.removeAll()
                models.savedRates.removeAll()
                self.savedQty.removeAll()
                for i in resultArray.arrayValue {
                    let id = i["id"].stringValue
                    models.id.append(id)
                    let name = i["name"].stringValue
                    models.name.append(name)
                    let rate = i["rate"].stringValue
                    models.rate.append(rate)
                }
                for i in 0...models.id.count {
                    models.savedAmount.append("0")
                    models.savedItems.append("0")
                    models.savedRates.append("0")
                }
                for q in 0...models.id.count {
                    models.savedQTY.append("0")
                }
                print("m:- \(models.savedQTY)")
                self.table.reloadData()
                self.view.activityStopAnimating()
                break
            case .failure:
                print(response.debugDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("lalal")
        models.id.removeAll()
               models.name.removeAll()
               models.rate.removeAll()
               models.savedQTY.removeAll()
               models.savedAmount.removeAll()
               models.savedItems.removeAll()
               models.savedRates.removeAll()
        FetchDetails()
        CustomizeNavBar()
        CustomizeView()
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 70
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  FetchDetails()
//        models.id.removeAll()
//        models.name.removeAll()
//        models.rate.removeAll()
//        models.savedQTY.removeAll()
//        models.savedAmount.removeAll()
//        models.savedItems.removeAll()
//        models.savedRates.removeAll()
//        self.savedQty.removeAll()
//        print("lalal")
//        FetchDetails()
//        CustomizeNavBar()
//        CustomizeView()
//        table.rowHeight = UITableView.automaticDimension
//        table.estimatedRowHeight = 70
//        print("kalla")
    }
    
    @IBAction func CreateInvoice(_ sender: UIButton){
        CustomizeView()
        print("mysavedams:- \(models.savedAmount)")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateInvoiceViewController") as! CreateInvoiceViewController
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ViewInvoices(_ sender: UIButton){
        CustomizeViewInvoceView()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewTableViewController") as! ViewTableViewController
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
//        webview = WKWebView()
//        webview.navigationDelegate = self
//        view = webview
//        let url = URL(string: "http://sparklemanufacturing.com/api/Welcome")!
//        webview.load(URLRequest(url: url))
//        webview.allowsBackForwardNavigationGestures = true
    }
    
    @IBAction func Logout(_ sender: UIButton){
        UserDefaults.standard.removeObject(forKey: "UserHasSubmittedPassword")
        KeychainWrapper.standard.removeAllKeys()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.id.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "homecell") as! HomeTableViewCell
        cell.items.text = models.name[indexPath.row]
        cell.rates.text = models.rate[indexPath.row]
      
        //cell.amounts.text = cell.qty.text
//        cell.qty.addTarget(self, action: #selector(textfieldDidChange(textfield:)), for: .editingDidEnd)
//        cell.qty.tag = indexPath.row
        
        cell.butt.addTarget(self, action: #selector(open), for: .touchUpInside)
        cell.butt.tag = indexPath.row
        print("savd:- \(models.savedAmount)")
        print("savd:- \(models.id.count)")
       // if selectedstarplayer1.contains(indexPath.row) {
       // if models.savedAmount.count > 0 {
            cell.amounts.text = models.savedAmount[indexPath.row]
            cell.qtlbl.text = models.savedQTY[indexPath.row]
            print("hurray")
//        } else {
//            cell.amounts.text = "0"
//            cell.qtlbl.text = "0"
//            print("no way")
//        }
            
            //cell.butt.setTitle(models.savedQTY[indexPath.row], for: .normal)
//              } else {
//                  cell.amounts.text = ""
//                  cell.qty.text = ""
//              }
        return cell
    }
    
    @objc func open(_ sender: UIButton){
        let setvalue = models.name[sender.tag]
        let alertController = UIAlertController(title: setvalue, message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            // do something with textField
             
            self.selectedstarplayer1.append(sender.tag)
            let demo = textField.text
            guard let changeValue = Int(demo ?? "") else { return }
            let multiplyamount = models.rate[sender.tag]
            let changemultiply = Int(multiplyamount)
            let finalValue = changeValue * changemultiply!
            let changestring = String(finalValue)
            let divide = finalValue / changemultiply!
            let changeDivide = String(divide)
            let fixedItems = models.id[sender.tag]
            let fixedRates = models.rate[sender.tag]
            models.savedItems[sender.tag] = fixedItems
            models.savedRates[sender.tag] = fixedRates
            models.savedQTY[sender.tag] = demo ?? ""//changeDivide
            models.savedAmount[sender.tag] = changestring
            print("sd:- \(models.savedQTY)")
            print("we:- \(models.savedAmount)")
            self.table.reloadData()
            print("after:- \(self.changeQty)")
            
        }))
    
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = "Enter Value"
        })
        self.present(alertController, animated: true, completion: nil)
    }
}
