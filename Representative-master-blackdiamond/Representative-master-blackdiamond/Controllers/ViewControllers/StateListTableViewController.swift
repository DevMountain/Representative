//
//  StateListTableViewController.swift
//  Representative-master
//
//  Created by Eric Lanza on 1/16/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class StateListTableViewController: UITableViewController {

    @IBOutlet weak var lastNameTextField: UITextField!
    
    // Make the next textfield's keyboard close on search tap
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        lastNameTextField.resignFirstResponder()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return States.all.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath)

        let state = States.all[indexPath.row]
        
        cell.textLabel?.text = state

        return cell
    }
   
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stateSearchSegue" {
            guard let destinationVC = segue.destination as? StateDetailTableViewController, let index = tableView.indexPathForSelectedRow else { return }
            
            destinationVC.state = States.all[index.row]
        }
        
        // Black Diamond: Send last name data to the next table view controller to search by last name.
        if segue.identifier == "lastNameSearchSegue" {
            guard let destinationVC = segue.destination as? StateDetailTableViewController, let lastName = lastNameTextField.text, !lastName.isEmpty else { return }
            destinationVC.lastName = lastName
        }
    }
}

// Black Diamond: Make the new text field keyboard close on return button
// Don't forget to set the textfield's delegate in storyboard
extension StateListTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
