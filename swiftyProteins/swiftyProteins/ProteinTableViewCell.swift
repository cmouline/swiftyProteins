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
 
    var protein : String? {
        didSet {
            if let p = protein {
                ligandLabel?.text = p
            }
        }
    }

}
