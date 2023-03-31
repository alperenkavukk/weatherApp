//
//  weatherTableViewCell.swift
//  weatherApp3
//
//  Created by Alperen Kavuk on 28.03.2023.
//

import UIKit

class weatherTableViewCell: UITableViewCell {

    @IBOutlet weak var summaryLbl: UILabel!
    @IBOutlet weak var iconLbl: UIImageView!
    @IBOutlet weak var temperaturLbl: UILabel!
    @IBOutlet weak var dataLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
