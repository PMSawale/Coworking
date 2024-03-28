//
//  desBookingCell.swift
//  Coworking
//
//  Created by Pankaj Sawale on 25/03/24.
//

import UIKit

class desBookingCell: UITableViewCell {
    @IBOutlet weak var deskIDLbl: UILabel!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var bookedOnLbl: UILabel!
    @IBOutlet weak var bookingView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
