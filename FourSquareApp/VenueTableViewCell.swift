//
//  VenueTableViewCell.swift
//  FourSquareApp
//
//  Created by Manisha  Sharma on 19/12/2017.
//  Copyright © 2017 Qualwebs. All rights reserved.
//

import UIKit

class VenueTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelContactNumber: UILabel!
    @IBOutlet weak var buttonShowOnMap: UIButton!
    
    var showLocationTapped: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    @IBAction func showLocationAction(_ sender: UIButton) {
        if let showLocationTapped = showLocationTapped {
            showLocationTapped()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
