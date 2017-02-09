//
//  ViewController.swift
//  swiftyProteins
//
//  Created by Chloe MOULINET on 2/8/17.
//  Copyright © 2017 Chloe MOULINET. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var conectArray: [[(x: Float, y: Float, z: Float, type: String)]] = []
    var atomArray: [(x: Float, y: Float, z: Float, type: String)] = []

    func createPairs(conect: [Int]) {
        
        for i in 1..<(conect.count) {
            conectArray.append([atomArray[conect[0]], atomArray[conect[i]]])
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
        
        let myURLString = "https://files.rcsb.org/ligands/view/V11_ideal.pdb"
        
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return
        }
        
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
//            print("ATOMARRAY : \(atomArray)")
//            print("CONECTARRAY : \(conectArray)")
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

