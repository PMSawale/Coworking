//
//  desk.swift
//  Coworking
//
//  Created by Pankaj Sawale on 23/03/24.
//

import UIKit

class desk: UIViewController {
    @IBOutlet weak var calendarView: UICollectionView!
    @IBOutlet weak var timingView: UICollectionView!
    var slotsData = [Slots]()
    var slotAct = false
    var date  = "00"
    var month = "00"
    let year = "2024"
    var day = ""
    var timing = ""
    var slotId = 0
    var dateAndTimingString: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if let flowLayout = timingView.collectionViewLayout as? UICollectionViewFlowLayout {
          flowLayout.sectionInset.bottom = flowLayout.itemSize.width / 2
        }
    }
    
    func getslots(dateString: String) {
            guard let url = URL(string: API.getSlots + dateString) else {
                return
            }
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            guard let data = data, error == nil else
            {
                print("Error in parsing Data")
                return
            }
            var slot:getSlots?
            do
            {
                slot = try JSONDecoder().decode(getSlots.self, from: data)
                print("Json Responseeeeeb \(slot)")
                
            }
            catch
            {
                print("ERROR hjkhh\(error)")
            }
            self.slotsData = slot!.slots
            DispatchQueue.main.async {
                self.timingView.reloadData()
            }
        })
        
        task.resume()
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }

    
    
    @IBAction func next(_ sender: Any) {
        // Check if collectionView1 has any selected cells
        let isCollectionView1Selected = calendarView.indexPathsForSelectedItems != nil && !calendarView.indexPathsForSelectedItems!.isEmpty

        let isCollectionView2Selected = timingView.indexPathsForSelectedItems != nil && !timingView.indexPathsForSelectedItems!.isEmpty

        if isCollectionView1Selected && isCollectionView2Selected {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "availabelDesk") as? availabelDesk
            vc?.dayDt = dateAndTimingString
            vc?.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true)
        } else {
            showToast(message: "Please select all Fields.", duration: 2.0)
        }
        
    }
    
    var dayData = ["Wed","Thu","Fri","Sat","Sun","Mon","Tue","Wed","Thu","Fri","Sat","Sun","Mon","Tue","Wed","Thu","Fri","Sat","Sun","Mon","Tue","Wed","Thu","Fri","Sat","Sun","Mon","Tue","Wed","Thu","Fri","Sat","Sun","Mon","Tue","Wed","Thu","Fri","Sat","Sun","Mon","Tue","Wed","Thu","Fri","Sat","Sun","Mon","Tue","Wed","Thu","Fri","Sat","Sun","Mon","Tue","Wed","Thu","Fri","Sat","Sun","Mon"]
    var dateData = ["31","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"]
    var monthData = ["May","Jun","Jun","Jun","Jun","Jun","Jun","Jun","Jun","Jun","Jun","Jun","Jun","Jun","Jun","Jun","Jun","Jun","Jun","Jun","Jun","Jun","Jun","Jun","Jun","Jun","Jun","Jun","Jun","Jun","Jun","July","July","July","July","July","July","July","July","July","July","July","July","July","July","July","July","July","July","July","July","July","July","July","July","July","July","July","July","July","July","July"]

}

extension desk: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if collectionView == timingView {
            return slotsData.count
        } else if collectionView == calendarView {
            return dayData.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == timingView {
            
            let data = slotsData[indexPath.item]
            let cell2 = timingView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! timingCell
            cell2.timingVu.layer.cornerRadius = 7
            cell2.timingVu.layer.borderWidth = 1
            cell2.timingVu.layer.borderColor = UIColor.lightGray.cgColor
            cell2.slotActive = data.slot_active
            slotAct = cell2.slotActive
            if cell2.slotActive == true {
                cell2.timingVu.backgroundColor = UIColor(red: 199/255.0, green: 207/255.0, blue: 252/255.0, alpha: 1)
            } else if cell2.slotActive == false {
                cell2.timingVu.backgroundColor = UIColor(red: 227/255.0, green: 227/255.0, blue: 227/255.0, alpha: 1)
            }
            cell2.timimgLbl.text = data.slot_name
            
            return cell2
        } else if collectionView == calendarView {
            let cell_1 = calendarView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! dateCell
            cell_1.dateView.backgroundColor = .white
            cell_1.dayLbl.text = dayData[indexPath.row]
            cell_1.dateLbl.text = dateData[indexPath.row]
            cell_1.monthLbl.text = monthData[indexPath.row]
            return cell_1
        }
         return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if collectionView == calendarView {
            if let cell_1 = collectionView.cellForItem(at: indexPath) as? dateCell {
                cell_1.dateView.backgroundColor = UIColor(red: 77/255.0, green: 96/255.0, blue: 209255.0, alpha: 1)
                day = cell_1.dayLbl.text ?? "Wed"
                date = cell_1.dateLbl.text ?? "31"
                month = cell_1.monthLbl.text ?? "May"
                if cell_1.monthLbl.text == "May" {
                    month = "05"
                } else if cell_1.monthLbl.text == "Jun" {
                    month = "06"
                } else if cell_1.monthLbl.text == "July" {
                    month = "07"
                }
                var dateString = "\(year)-\(month)-\(date)"
                UserDefaults.standard.set(dateString, forKey: "dateString")
                getslots(dateString: dateString)
                timingView.reloadData()
            }
        } else if collectionView == timingView {
            if let cell2 = collectionView.cellForItem(at: indexPath) as? timingCell {
                cell2.timingVu.isUserInteractionEnabled = false
                timing = cell2.timimgLbl.text ?? "05:00PM-06:00PM"
                let data = slotsData[indexPath.item]
                cell2.slotsId = data.slot_id
                slotId = cell2.slotsId
                cell2.slotActive = data.slot_active
                slotAct = cell2.slotActive
                UserDefaults.standard.set(slotId, forKey: "slotId")
                if slotAct == true {
                    cell2.timingVu.backgroundColor = UIColor(red: 77/255.0, green: 96/255.0, blue: 209255.0, alpha: 1)
                } else if slotAct == false {
                    collectionView.deselectItem(at: indexPath, animated: true)
                }
                if month == "05" {
                    month = "May"
                } else if month == "06" {
                    month = "Jun"
                } else if month == "07" {
                    month = "July"
                }
                dateAndTimingString = "\(day) \(date) \(month), \(timing)"
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == calendarView {
            if let cell_1 = collectionView.cellForItem(at: indexPath) as? dateCell {
                cell_1.dateView.backgroundColor = UIColor.white
                
            }

        } else if collectionView == timingView {
            if let cell2 = collectionView.cellForItem(at: indexPath) as? timingCell {
                cell2.timingVu.backgroundColor = UIColor(red: 227/255.0, green: 227/255.0, blue: 227/255.0, alpha: 1)
                
            }
        }
    }
    
}

