//
//  deskBooking.swift
//  Coworking
//
//  Created by Pankaj Sawale on 23/03/24.
//

import UIKit

class deskBooking: UIViewController {
    var id = 0
    @IBOutlet weak var tablView: UITableView!
    var bookingData = [Bookings]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int {
            print("User ID retrieved from UserDefaults: \(userId)")
            id = userId
        }
        
        // Do any additional setup after loading the view.
        getBookings()
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
        func getBookings() {
        var idString = String(id)
            guard let url = URL(string: API.getBooking + idString) else {
                return
            }
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            guard let data = data, error == nil else
            {
                print("Error in parsing Data")
                return
            }
            var booking:getBooking?
            do
            {
                booking = try JSONDecoder().decode(getBooking.self, from: data)
                print("Json Responseeeeeb \(booking)")
                
            }
            catch
            {
                print("ERROR hjkhh\(error)")
            }
            self.bookingData = booking!.bookings
            DispatchQueue.main.async {
                self.tablView.reloadData()
            }
        })
        
        task.resume()
    }

}

extension deskBooking: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return bookingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = bookingData[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! desBookingCell
        cell.deskIDLbl.text = "\(data.workspace_id)"
        cell.bookedOnLbl.text = data.booking_date
        cell.NameLbl.text = data.workspace_name
        cell.bookingView.layer.cornerRadius = 10
        return cell
    }
    
    
}
