//
//  ViewController.swift
//  SMPL Supplier
//
//  Created by Family on 04/11/20.
//  Copyright © 2020 Family. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Lottie
import SwiftKeychainWrapper

class ViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var LoginView: UIView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        
        emailField.delegate = self
        passwordField.delegate = self
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK:- Customize Textfields
    fileprivate func CustomizeTextFields() {
        emailField.attributedPlaceholder = NSAttributedString(string: " Enter Email/User Name",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 50/255, green: 70/255, blue: 94/255, alpha: 1.0)])
        passwordField.attributedPlaceholder = NSAttributedString(string: " Enter Password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 50/255, green: 70/255, blue: 94/255, alpha: 1.0)])
    }
    
    //MARK:- Customize Buttons
    fileprivate func CustomizeButtons() {
       // self.signInBtn.layer.cornerRadius = self.signInBtn.bounds.size.height/2
    }
    
    //MARK:- Customize Views
    fileprivate func CustomizeViews() {
//        LoginView.layer.cornerRadius = 15
//        LoginView.clipsToBounds = true
//        LoginView.layer.masksToBounds = false
//        LoginView.layer.shadowRadius = 7
//        LoginView.layer.shadowOpacity = 0.6
//        LoginView.layer.shadowOffset = CGSize(width: 0, height: 5)
//        LoginView.layer.shadowColor = UIColor.gray.cgColor
    }
    
    func LoginFetch(email: String, password: String) {
        self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.2))
        let header:HTTPHeaders = [
            "X-API-KEY": Constants.XAPIKey
        ]
        
        let parameters = [
            "email": email,
            "password": password
        ]
        
        AF.request(Constants.BaseURL+Constants.Login, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: header).authenticate(username: "admin", password: "1234").responseJSON{ response in
            switch response.result {
            case .success:
                print("result:- \(response.result)")
                let myresult = try? JSON(data: response.data!)
                let resultArray = myresult!["status"].bool
                let message = myresult!["message"].stringValue
                if resultArray == true {
                    print("sure")
                    self.view.activityStopAnimating()
                    UserDefaults.standard.set(true, forKey: "UserHasSubmittedPassword")
                    self.performSegue(withIdentifier: "LoginToHome",sender: nil)
                    let data = myresult!["data"].dictionaryValue
                    let supplier_id = data["supplier_id"]?.stringValue
                    KeychainWrapper.standard.set(supplier_id ?? "", forKey: "supplierID")
                } else {
                    self.view.activityStopAnimating()
                    // the alert view
                    let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)

                    // change to desired number of seconds (in this case 5 seconds)
                    let when = DispatchTime.now() + 1
                    DispatchQueue.main.asyncAfter(deadline: when){
                      // your code with delay
                      alert.dismiss(animated: true, completion: nil)
                    }
            }
                print(resultArray)
                break
            case .failure:
                print(response.debugDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
               // Always adopt a light interface style.
               overrideUserInterfaceStyle = .light
           }
        CustomizeViews()
        CustomizeButtons()
        CustomizeTextFields()
    }
    
    @IBAction func SignInAction(signinButtonPressed sender: UIButton) {
        if validate() {
            LoginFetch(email: self.emailField.text ?? "", password: self.passwordField.text ?? "")
        }
    }
    
    //MARK:- Supporting Functions
    func validate() -> Bool {
        guard self.emailField.text!.count > 0 else {
            self.show(alertWithTitle: "Supplier Alert",
                      message: "Please Enter Email/User-ID")
            return false
        }
        guard self.passwordField.text!.count > 0 else {
            self.show(alertWithTitle: "Supplier Alert",
                      message: "Please Enter Password")
            return false
        }
        
        return true
    }
}

