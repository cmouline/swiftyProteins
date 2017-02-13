//
//  ProteinTableViewCell.swift
//  swiftyProteins
//
//  Created by Chloe MOULINET on 2/13/17.
//  Copyright © 2017 Chloe MOULINET. All rights reserved.
//

import UIKit

class ProteinTableViewCell: UITableViewCell {

    @IBOutlet weak var ligandLabel: UILabel!
    @IBOutlet weak var chemicalNameLabel: UILabel!
    @IBOutlet weak var formulaLabel: UILabel!
 
    var protein : (String, String, String)? {
        didSet {
            if let p = protein {
                ligandLabel?.text = p.0
                chemicalNameLabel?.text = p.1
                formulaLabel?.text = p.2
            }
        }
    }

}
