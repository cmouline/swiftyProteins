//
//  ViewController.swift
//  swiftyProteins
//
//  Created by Chloe MOULINET on 2/8/17.
//  Copyright © 2017 Chloe MOULINET. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    func parseHTML() {
        
        let myURLString = "https://files.rcsb.org/ligands/view/V11_ideal.pdb"
        
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return
        }
        
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
            let htmlContent = myHTMLString.characters.split(separator: "\n").map(String.init)
            for line in htmlContent {
                let elem = line.characters.split(separator: " ").map(String.init)
                if elem[0] == "ATOM" {
                    print("ATOM : \(elem)")
                } else if elem[0] == "CONECT" {
                    print("CONECT : \(elem)")
                }
            }
            //            print("HTML : \()")
        } catch let error {
            print("Error: \(error)")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        parseHTML()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

