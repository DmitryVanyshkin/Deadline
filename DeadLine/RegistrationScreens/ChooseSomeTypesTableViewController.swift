//
//  ChooseSomeTypesTableViewController.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 05/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import UIKit

class ChooseSomeTypesTableViewController: UITableViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var filteredData = [String]()
    private let overallData = ApplicationData.shared.getData
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    


    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredData.count
        }
        return overallData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoDataCell", for: indexPath) as! InfoDataCell
        
        if isFiltering{
            cell.textContent.text = filteredData[indexPath.row]
        }
        
        else{
            cell.textContent.text = overallData[indexPath.row]
        }
        // Configure the cell...

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let content = (tableView.cellForRow(at: indexPath) as! InfoDataCell).textContent.text else{
            return
        }
        if ApplicationData.shared.getUserToAdd == nil{
            ApplicationData.shared.createUserToAdd()
        }
        switch  ApplicationData.shared.getDisplay {
        case .minors:
            ApplicationData.shared.getUserToAdd?.setMinor(minor: content)
        case .groupName:
            let educationAdd = ApplicationData.shared.getEducationProgramForName(name : content)
            ApplicationData.shared.getUserToAdd?.setProgramName(educationProgram : educationAdd)
        case .groupNumber:
            ApplicationData.shared.getUserToAdd?.setGroup(group: content)
        }

        tableView.deselectRow(at: indexPath, animated: true)
        //(self.navigationController as! RegistrationScreenNavigation).reloadInfoAtRegistrationScreen()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChooseSomeTypesTableViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        filteredData = overallData.filter({ (toSearch: String) -> Bool in
            return toSearch.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    
}
