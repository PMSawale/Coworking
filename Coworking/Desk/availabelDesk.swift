//
//  availabelDesk.swift
//  Coworking
//
//  Created by Pankaj Sawale on 23/03/24.
//

import UIKit

class availabelDesk: UIViewController {
    @IBOutlet weak var deskAvailabelView: UICollectionView!
    @IBOutlet weak var dayDate: UILabel!
    var availabelDeskData = [Availabilit]()
    var dayDt = ""
    var dateString = ""
    var slotId = 0
    var type = 0
    var workspaceAct = false
    var workId = 0
    var workspaceName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayDate.text = dayDt
        
        dateString = (UserDefaults.standard.object(forKey: "dateString") as? String)!
        
        slotId = (UserDefaults.standard.object(forKey: "slotId") as? Int)!
        
        type = (UserDefaults.standard.object(forKey: "type") as? Int)!
        
        getAvailabelDesk(dateString: dateString, slotId: slotId, type: type)
    }
    func getAvailabelDesk(dateString: String, slotId: Int, type: Int) {
        guard let url = URL(string: "\(API.availability)date=\(dateString)&slot_id=\(slotId)&type=\(type)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            guard let data = data, error == nil else
            {
                print("Error in parsing Data")
                return
            }
            var availability:getAvailability?
            do
            {
                availability = try JSONDecoder().decode(getAvailability.self, from: data)
                print("Json Responseeeeeb \(availability)")
            }
            catch
            {
                print("ERROR hjkhh\(error)")
            }
            self.availabelDeskData = availability!.availability
            DispatchQueue.main.async {
                self.deskAvailabelView.reloadData()
            }
        })
        
        task.resume()
    }

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func bookSlot(_ sender: Any) {
        let isCollectionViewSelected = deskAvailabelView.indexPathsForSelectedItems != nil && !deskAvailabelView.indexPathsForSelectedItems!.isEmpty
        
        if isCollectionViewSelected {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "confirmation") as? deskConfirmation
            vc?.dayDt = dayDt
            vc?.modalPresentationStyle = .overCurrentContext
            self.present(vc!, animated: false)
        } else {
            showToast(message:  "Please select Field.", duration: 2.0)
        }
    }
}

extension availabelDesk: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availabelDeskData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = availabelDeskData[indexPath.item]
        let cell = deskAvailabelView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! availabelDeskCell
        cell.avdeskView.layer.cornerRadius = 5
        cell.avdeskView.layer.borderWidth = 1
        cell.avdeskView.layer.borderColor = UIColor.lightGray.cgColor
        cell.workspaceActive = data.workspace_active
        workspaceAct = cell.workspaceActive
        if cell.workspaceActive == true {
            cell.avdeskView.backgroundColor = UIColor(red: 199/255.0, green: 207/255.0, blue: 252/255.0, alpha: 1)
        } else if cell.workspaceActive == false {
            cell.avdeskView.backgroundColor = UIColor(red: 227/255.0, green: 227/255.0, blue: 227/255.0, alpha: 1)
        }
        cell.avDeskLbl.text = data.workspace_name
        workspaceName = data.workspace_name
        UserDefaults.standard.set(workspaceName, forKey: "workspaceName")
        
    return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? availabelDeskCell {
            let data = availabelDeskData[indexPath.item]
            cell.workspaceActive = data.workspace_active
            workspaceAct = cell.workspaceActive
            cell.workspaceId = data.workspace_id
            workId = cell.workspaceId
            UserDefaults.standard.set(workId, forKey: "workId")
            if workspaceAct == true {
                cell.avdeskView.backgroundColor = UIColor(red: 77/255.0, green: 96/255.0, blue: 209255.0, alpha: 1)
            } else if workspaceAct == false {
                collectionView.deselectItem(at: indexPath, animated: true)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? availabelDeskCell {
            cell.avdeskView.backgroundColor = UIColor(red: 227/255.0, green: 227/255.0, blue: 227/255.0, alpha: 1)
            
        }
    }
}
