//
//  ViewController.swift
//  swiftyProteins
//
//  Created by Chloe MOULINET on 2/8/17.
//  Copyright © 2017 Chloe MOULINET. All rights reserved.
//

import UIKit
import SceneKit

class SceneViewController: UIViewController {

    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var selectedElementLabel: UILabel!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var conectArray: [[(x: Float, y: Float, z: Float, type: String)]] = []
    var atomArray: [(x: Float, y: Float, z: Float, type: String)] = []
    var ligand : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        title = ligand
        selectedElementLabel.text = ""
        parseHTML()
        initScene()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
        
        let myURLString = "https://files.rcsb.org/ligands/view/\(ligand)_ideal.pdb"
        
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL") // changer par un alert
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
            
        } catch let error {
            let ac = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
    }
    
    func initScene() {
        sceneView.scene = Scene(atoms : atomArray, conects : conectArray)
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(recognizer:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    func tapGesture(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: sceneView)
        
        let hitResults = sceneView.hitTest(location, options: nil)
        if hitResults.count > 0 {
            let result = hitResults[0] 
            let node = result.node
            if let atom = node.name {
                selectedElementLabel.text = "Selected element : " + atom.capitalized
            }
            else {
                selectedElementLabel.text = ""
            }
        }
        else {
            selectedElementLabel.text = ""
        }
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        sceneView.stop(nil)
//        sceneView.play(nil)
//    }
    
    @IBAction func shareAction(_ sender: UIBarButtonItem) {

        let image : UIImage = sceneView.snapshot()

        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [image], applicationActivities: nil)

        // Special iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            if activityViewController.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                activityViewController.popoverPresentationController?.barButtonItem = shareButton
            }
        }

        self.present(activityViewController, animated: true, completion: nil)
    }
    
}

