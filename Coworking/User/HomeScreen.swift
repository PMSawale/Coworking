//
//  HomeScreen.swift
//  Coworking
//
//  Created by Pankaj Sawale on 22/03/24.
//

import UIKit

class HomeScreen: UIViewController {
    @IBOutlet weak var bookDesk: UIButton!
    @IBOutlet weak var bookRoom: UIButton!
    var type = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        type = 0
    }
    
    @IBAction func bookingHIstory(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "bookingHistory") as? deskBooking
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true)
    }
    
    @IBAction func bookDeskTapped(_ sender: Any) {
        type = 1
        UserDefaults.standard.set(type, forKey: "type")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "desk") as? desk
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true)
    }
    @IBAction func bookRoomTapped(_ sender: Any) {
        type = 2
        UserDefaults.standard.set(type, forKey: "type")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "desk") as? desk
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true)
    }

}
