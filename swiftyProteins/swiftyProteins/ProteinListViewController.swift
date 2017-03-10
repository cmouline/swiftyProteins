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
    var conectArray : [[(x: Float, y: Float, z: Float, type: String)]] = []
    var atomArray : [(x: Float, y: Float, z: Float, type: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getProteinList()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.autocapitalizationType = UITextAutocapitalizationType.allCharacters
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        searchController.searchBar.becomeFirstResponder()
    }
    
    func createPairs(conect: [Int]) {
        let atomArrayCount = atomArray.count
        
        for i in 1..<(conect.count) {
            if conect[0] < atomArrayCount && conect[i]  < atomArrayCount {
                conectArray.append([atomArray[conect[0]], atomArray[conect[i]]])
            }
        }
        
    }
    
    func fillConectArray(elem: [String]) {
        
        var elem = elem
        var conect: [Int] = []
        elem.remove(at: 0)
        
        for conectList in elem {
            
            let conectInt = Int(conectList)
            let indexExists = conect.indices.contains(0)
            
            if !indexExists || conectInt! > conect[0] {
                conect.append(conectInt! - 1)
            }
            
        }
        
        if conect.count > 1 {
            createPairs(conect: conect)
        }
        
    }
    
    func parseHTML() {
        
        let myURLString = "https://files.rcsb.org/ligands/view/\(selectedLigand!)_ideal.pdb"
        
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return
        }
        
        conectArray = []
        atomArray = []
        
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
            let htmlContent = myHTMLString.characters.split(separator: "\n").map(String.init)
            
            for line in htmlContent {
                
                var elem = line.characters.split(separator: " ").map(String.init)
                
                if elem[0] == "ATOM" {
                    
                    atomArray.append(((elem[6] as NSString).floatValue, (elem[7] as NSString).floatValue, (elem[8] as NSString).floatValue, elem[11]))
                    
                } else if elem[0] == "CONECT" {
                    
                    fillConectArray(elem: elem)
                    
                }
                
            }
            
        } catch let error {
            print("Error: \(error)")
            let ac = UIAlertController(title: "Error", message: "Something wrong happened with this ligand", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            ac.view.tintColor = UIColor.red // change text color of the buttons
            ac.view.backgroundColor = UIColor.red  // change background color
            ac.view.layer.cornerRadius = 25   // change corner radius
            present(ac, animated: true)
        }
        
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
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            parseHTML()
            if !atomArray.isEmpty {
                performSegue(withIdentifier: "toScene", sender: self)
            } else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                let ac = UIAlertController(title: "Error", message: "Ligand file is empty", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                ac.view.tintColor = UIColor.red // change text color of the buttons
                ac.view.backgroundColor = UIColor.red  // change background color
                ac.view.layer.cornerRadius = 25   // change corner radius
                present(ac, animated: true)
            }
        }
    }
    
    // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "toScene" {
             if let vc = segue.destination as? SceneViewController {
                vc.ligand = self.selectedLigand!
                vc.atomArray = self.atomArray
                vc.conectArray = self.conectArray
             }
         }
     }
    
}

