//
//  deskConfirmation.swift
//  Coworking
//
//  Created by Pankaj Sawale on 23/03/24.
//

import UIKit

class deskConfirmation: UIViewController {
    @IBOutlet weak var deskIdLbl1: UILabel!
    @IBOutlet weak var deskIdLbl2: UILabel!
    @IBOutlet weak var deskNo: UILabel!
    @IBOutlet weak var dayDateString: UILabel!
    @IBOutlet weak var ConfirmView: UIView!
    @IBOutlet weak var headView: UIView!
    
    var workspaceName = ""
    var dayDt = ""
    var dateString = ""
    var slotId = 0
    var type = 0
    var workId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        dateString = (UserDefaults.standard.object(forKey: "dateString") as? String)!
        
        slotId = (UserDefaults.standard.object(forKey: "slotId") as? Int)!
        
        type = (UserDefaults.standard.object(forKey: "type") as? Int)!
        
        workId = (UserDefaults.standard.object(forKey: "workId") as? Int)!
        workspaceName = (UserDefaults.standard.object(forKey: "workspaceName") as? String)!
        
        
        if workId == 1 {
            deskIdLbl1.text = "Desk Id :"
            deskNo.text = "Desk \(workspaceName)"
        } else if workId == 2 {
            deskIdLbl1.text = "Room Id :"
            deskNo.text = "Room No.\(workspaceName)"
        }
        dayDateString.text = dayDt
        var wrokIdString = String(workId)
        deskIdLbl2.text = wrokIdString
        
        ConfirmView.layer.cornerRadius = 10
        headView.layer.cornerRadius = 10
    }

    @IBAction func back(_ sender: Any) {
        dismiss(animated: false)
    }
    
    @IBAction func confirm(_ sender: Any) {
        deskConfirm()
    }
    func deskConfirm() {
        var urlRequest = URLRequest(url: URL(string: API.deskConfrim)!)
        urlRequest.httpMethod = "POST"
        
        let dataDictionary = ["date": dateString, "slot_id": slotId, "workspace_id": workId, "type": type] as [String : Any]
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
                
                DispatchQueue.main.async {
                    do {
                        // Parse JSON data
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let message = jsonObject["message"] as? String {
                                self.showToastOfConfirmMsg(title: "Success", message: "\(message)", backgroundColor: .green)
                                print(message)
                            } else {
                                print("message not found in JSON")
                            }
                        } else {
                            print("Error parsing JSON data into dictionary")
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }
        }.resume()
    }
    
}

extension UIViewController {
    func showToastOfConfirmMsg(title: String, message: String, backgroundColor: UIColor, duration: TimeInterval = 2.0) {
        let toastView = UIView()
        toastView.backgroundColor = backgroundColor
        toastView.alpha = 0.0
        toastView.layer.cornerRadius = 10
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        toastView.addSubview(titleLabel)
        toastView.addSubview(messageLabel)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toastView)
        
        NSLayoutConstraint.activate([
            toastView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            toastView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            toastView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: toastView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: toastView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: toastView.trailingAnchor, constant: -16),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            messageLabel.leadingAnchor.constraint(equalTo: toastView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: toastView.trailingAnchor, constant: -16),
            messageLabel.bottomAnchor.constraint(equalTo: toastView.bottomAnchor, constant: -8)
        ])
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            toastView.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseIn, animations: {
                toastView.alpha = 0.0
            }, completion: { _ in
                toastView.removeFromSuperview()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeScreen") as? HomeScreen
                vc?.modalPresentationStyle = .fullScreen
                self.present(vc!, animated: false)
            })
        })
    }
}
