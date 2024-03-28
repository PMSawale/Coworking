//
//  CreateAnAccount.swift
//  Coworking
//
//  Created by Pankaj Sawale on 22/03/24.
//

import UIKit

class CreateAnAccount: UIViewController {
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var mobNumberText: UITextField!
    @IBOutlet weak var emailIdText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func creatAccount(_ sender: Any) {
        createUser()
    }
   func createUser() {
       if nameText.text == "" || mobNumberText.text == "" || emailIdText.text == "" {
           showToast(message: "Please Fill All the Field.", duration: 2.0)
       } else {
           var urlRequest = URLRequest(url: URL(string: API.Register)!)
           urlRequest.httpMethod = "POST"
           
           let dataDictionary = ["email": emailIdText.text!, "name": nameText.text!, "mobile_number": mobNumberText.text!]
           do {
               let requestBody = try JSONSerialization.data(withJSONObject: dataDictionary, options: .prettyPrinted)
               
               urlRequest.httpBody = requestBody
               urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
           } catch let error {
               print(error.localizedDescription)
           }
           
           URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
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
    
    @IBAction func logInPage(_ sender: Any) {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "login") as? LogIn
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true)

    }

}
extension UIViewController {
    func showToast(message: String, duration: TimeInterval = 2.0) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }
}
