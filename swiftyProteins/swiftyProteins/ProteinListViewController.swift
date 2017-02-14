//
//  ProteinListViewController.swift
//  swiftyProteins
//
//  Created by Chloe MOULINET on 2/9/17.
//  Copyright © 2017 Chloe MOULINET. All rights reserved.
//

import UIKit

class ProteinListViewController: UITableViewController, UISearchResultsUpdating {

    var proteinList: [String] = []
    var filteredProteinList: [String] = []
    let searchController = UISearchController(searchResultsController: nil)
    var selectedLigand : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        getProteinList()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.autocapitalizationType = UITextAutocapitalizationType.allCharacters
    }
    
    func getProteinList() {
        
        let fileURLProject = Bundle.main.path(forResource: "Ligands", ofType: "")
        
        do {
            
            var readStringProject = try String(contentsOfFile: fileURLProject!, encoding: String.Encoding.utf8)
            proteinList = readStringProject.characters.split(separator: "\n").map(String.init)

            
        } catch let error as NSError {
            
            print("Failed reading from URL: \(fileURLProject), Error: " + error.localizedDescription)
            
        }
        
    }

    // MARK: - Search Bar and Filter Functions

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }

    func filterContentForSearchText(searchText: String, scope: String = "All") {

        filteredProteinList = proteinList.filter { protein in
            var hasSubstring = false
            if protein.lowercased().range(of: searchText.lowercased()) != nil {
                hasSubstring = true
            }
            return hasSubstring
        }

        tableView.reloadData()
    }

    // MARK: - Table view data source

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    */
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredProteinList.count
        }
        return proteinList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "proteinCell", for: indexPath) as! ProteinTableViewCell
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.protein = filteredProteinList[indexPath.row]
        } else {
            cell.protein = proteinList[indexPath.row]
        }
        if indexPath.row % 2 == 0 {
            cell.backgroundColor? = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1.0)
        } else {
            cell.backgroundColor? = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        }
        return cell

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedLigand = searchController.isActive && searchController.searchBar.text != "" ?
            self.filteredProteinList[indexPath.row] : self.proteinList[indexPath.row]
        print("selected Ligand : \(self.selectedLigand ?? "nil")")
        if self.selectedLigand != nil {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            performSegue(withIdentifier: "toScene", sender: self)
        }
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
    
    // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "toScene" {
             if let vc = segue.destination as? SceneViewController {
                 vc.ligand = self.selectedLigand!
             }
         }
     }
    
}

