//
//  ViewController.swift
//  swiftyProteins
//
//  Created by Chloe MOULINET on 2/8/17.
//  Copyright © 2017 Chloe MOULINET. All rights reserved.
//

import UIKit
import SceneKit
import AEXML

class SceneViewController: UIViewController {

    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var selectedElementLabel: UILabel!
    @IBOutlet weak var chemicalNameLabel: UILabel!
    @IBOutlet weak var formulaLabel: UILabel!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var conectArray : [[(x: Float, y: Float, z: Float, type: String)]] = []
    var atomArray : [(x: Float, y: Float, z: Float, type: String)] = []
    var sceneType : String = "classic"
    var hydrogens : Bool = true
    var ligand : String = ""
    var xml: Data?
    var ligandData : (ligand: String, chemicalName: String, formula: String)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = ligand
        selectedElementLabel.text = ""
        getXML()
        initScene()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    
    func getXML() {
        
        let url = NSURL(string: "http://www.rcsb.org/pdb/rest/describeHet?chemicalID=\(ligand)")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let err = error {
                print("error1")
                print(err)
            } else if let d = data {
                
                self.xml = d
                self.parseXML()
                
            }
            
        }
        task.resume()
    }
    
    func parseXML() {
        
        do {
            
            let xmlDoc = try AEXMLDocument(xml: xml!, options: AEXMLOptions())
            
            ligandData = (ligand: ligand, chemicalName: xmlDoc.root["ligandInfo"]["ligand"]["chemicalName"].value ?? "chemicalNameDefault", formula: xmlDoc.root["ligandInfo"]["ligand"]["formula"].value ?? "formulaDefault")
            
            DispatchQueue.main.async {
                // display data
                if let chemicalName = self.ligandData?.chemicalName {
                    self.chemicalNameLabel.text = "Chemical name : \(chemicalName)"
                }
                if let formula = self.ligandData?.formula {
                    self.formulaLabel.text = "Formula : \(formula)"
                }
                
            }
            
        } catch {
            print("\(error)")
        }
    }
    
    func initScene() {
        sceneView.scene = Scene(atoms : atomArray, conects : conectArray, sceneType : sceneType, hydrogens : hydrogens)
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        sceneView.stop(nil)
        sceneView.play(nil)
    }
    
    @IBAction func shareAction(_ sender: UIBarButtonItem) {

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let renderer = UIGraphicsImageRenderer(size: sceneView.bounds.size)
        let image = renderer.image { ctx in
            sceneView.drawHierarchy(in: sceneView.bounds, afterScreenUpdates: false)
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
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
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            sceneType = "classic"
        case 1:
            sceneType = "modern"
        case 2:
            sceneType = "compact"
        default:
            break
        }
        sceneView.scene = Scene(atoms : atomArray, conects : conectArray, sceneType : sceneType, hydrogens : hydrogens)
    }
    
    @IBAction func displayHydrogens(_ sender: UIButton) {
        hydrogens = !hydrogens
        sceneView.scene = Scene(atoms : atomArray, conects : conectArray, sceneType : sceneType, hydrogens : hydrogens)
    }
    
    
}

