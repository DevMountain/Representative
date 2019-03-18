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
    weak var delegate: RepresentativeTableViewCellDelegate?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    
    // Black Diamond: Change the labels to buttons and call delegate functions
    @IBAction func websiteButtonTapped(_ sender: Any) {
        delegate?.websiteButtonTapped(self)
    }
    
    @IBAction func callButtonTapped(_ sender: Any) {
        delegate?.callButtonTapped(self)
    }
    
    func updateViews() {
        nameLabel.text = representative?.name
        partyLabel.text = representative?.party
        districtLabel.text = representative?.district
        
    }
}

// Black Diamond: Create a custom delegate protocol to perform actions when the button is tapped
protocol RepresentativeTableViewCellDelegate: class {
    func websiteButtonTapped(_ sender: RepresentativeTableViewCell)
    func callButtonTapped(_ sender: RepresentativeTableViewCell)
}
