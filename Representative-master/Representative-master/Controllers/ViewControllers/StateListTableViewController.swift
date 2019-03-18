//
//  StateListTableViewController.swift
//  Representative-master
//
//  Created by Eric Lanza on 1/16/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class StateListTableViewController: UITableViewController {

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
        if segue.identifier == "stateDetailSegue" {
            guard let destinationVC = segue.destination as? StateDetailTableViewController, let index = tableView.indexPathForSelectedRow else { return }
            
            destinationVC.state = States.all[index.row]
        }
    }
}
