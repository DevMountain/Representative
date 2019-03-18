//
//  RepresentativeTableViewCell.swift
//  Representative-master
//
//  Created by Eric Lanza on 1/16/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class RepresentativeTableViewCell: UITableViewCell {
    
    var representative: Representative? {
        didSet {
            updateViews()
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    func updateViews() {
        nameLabel.text = representative?.name
        partyLabel.text = representative?.party
        districtLabel.text = representative?.district
        websiteLabel.text = representative?.link
        phoneNumberLabel.text = representative?.phone
    }
}
