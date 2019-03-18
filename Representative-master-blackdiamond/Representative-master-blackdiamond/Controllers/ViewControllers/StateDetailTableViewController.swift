//
//  StateDetailTableViewController.swift
//  Representative-master
//
//  Created by Eric Lanza on 1/16/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class StateDetailTableViewController: UITableViewController {
    
    var representatives: [Representative] = [] {
        didSet {
            // Black Diamond: Display an alert if the representative gets set as an empty array saying no reps were found, and in the okay button, automatically pop the view controller back to the search controller.
            if representatives.isEmpty {
                let alertController = UIAlertController(title: "No Representatives found for that search", message: "Please go back and try agian", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Okay", style: .default) { (_) in
                    DispatchQueue.main.async {                        
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                alertController.addAction(okayAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var state: String?
    var lastName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Black Diamond: Search for rep by last name
        if let lastName = lastName {
            title = lastName.capitalized
            RepresentativeController.searchforRepresentativeBy(lastName: lastName) { (repArray) in
                self.representatives = repArray
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
        if let state = state {
            title = state
            RepresentativeController.searchRepresentatives(forState: state) { (repArray) in
                self.representatives = repArray
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return representatives.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "representativeCell", for: indexPath) as? RepresentativeTableViewCell else { return UITableViewCell() }

        // Black Diamond: Set Cell's delegate to self
        cell.delegate = self
        cell.representative = representatives[indexPath.row]

        return cell
    }
}

// Black Diamond: Confrom to the cell delegate and write our the function
// Guard against a missing website or phone number, and make sure the URL is valid before calling the .open method
extension StateDetailTableViewController: RepresentativeTableViewCellDelegate {
    func websiteButtonTapped(_ sender: RepresentativeTableViewCell) {
        guard let website = sender.representative?.link, let url = URL(string: website), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    func callButtonTapped(_ sender: RepresentativeTableViewCell) {
        guard let phoneNumber = sender.representative?.phone, let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) else { return }
        
        UIApplication.shared.open(url)
    }
    
    
}
