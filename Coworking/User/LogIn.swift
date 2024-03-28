//
//  LogIn.swift
//  Coworking
//
//  Created by Pankaj Sawale on 22/03/24.
//

import UIKit

class LogIn: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passPage: UITextField!
    
    var iconClick = false
    let imageIcon = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        imageIcon.image = UIImage(named: "closeeye")
        
        let contentView = UIView()
        contentView.addSubview(imageIcon)
        
        contentView.frame = CGRect(x: 0, y: 0, width: UIImage(named: "closeeye")!.size.width, height: UIImage(named: "closeeye")!.size.height)
        
        imageIcon.frame = CGRect(x: -10, y: 0, width: UIImage(named: "closeeye")!.size.width, height: UIImage(named: "closeeye")!.size.height)
        passPage.rightView = contentView
        passPage.rightViewMode = .always
        
        let tapGuestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGuestureRecogniser:)))
        imageIcon.isUserInteractionEnabled = true
        imageIcon.addGestureRecognizer(tapGuestureRecognizer)
    }
    
    @objc func imageTapped(tapGuestureRecogniser:UITapGestureRecognizer) {
        let tapImage = tapGuestureRecogniser.view as! UIImageView
        
        if iconClick
        {
            iconClick = false
            tapImage.image = UIImage(named: "openeye")
            passPage.isSecureTextEntry = false
        } else {
            iconClick = true
            tapImage.image = UIImage(named: "closeeye")
            passPage.isSecureTextEntry = true
        }
        
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        logInUser()
    }
    func logInUser(){
        if passPage.text == "" || emailText.text == ""{
            showToast(message: "Please Fill All the Field.", duration: 2.0)
            
        } else {
            var urlRequest = URLRequest(url: URL(string: API.LogIN)!)
            urlRequest.httpMethod = "post"
            
            let dataDictionary = ["email" : "\(emailText.text)", "password" : "\(passPage.text)"]
            do {
                let requestBody = try JSONSerialization.data(withJSONObject: dataDictionary, options: .prettyPrinted)
                
                urlRequest.httpBody = requestBody
                urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
            } catch let error {
                print(error.localizedDescription)
            }
            URLSession.shared.dataTask(with: urlRequest) { (data, httpurlResponse, error) in
                
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                guard let data = data else {
                    print("No data received")
                    return
                }
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                    
                    do {
                        // Parse JSON data
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let userId = jsonObject["user_id"] as? Int {
                                print("User ID: \(userId)")
                                UserDefaults.standard.set(userId, forKey: "userId")
                            } else {
                                print("User ID not found in JSON")
                            }
                        } else {
                            print("Error parsing JSON data into dictionary")
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }.resume()
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeScreen") as? HomeScreen
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true)
    }
    @IBAction func createAccountPage(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "create") as? CreateAnAccount
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true)   
    }

}
