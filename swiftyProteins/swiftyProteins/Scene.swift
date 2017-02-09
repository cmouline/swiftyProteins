//
//  Scene.swift
//  swiftyProteins
//
//  Created by Marie-pierre GUIRADO on 2/9/17.
//  Copyright © 2017 Chloe MOULINET. All rights reserved.
//

import UIKit
import SceneKit

class Scene: SCNScene {

    override init() {
        super.init()
        
//        self.size = sceneView.bounds.size;
//        setLights()
        
//        let sphereGeometry = SCNSphere(radius: 1.0)
//        let sphereNode = SCNNode(geometry: sphereGeometry)
//        self.rootNode.addChildNode(sphereNode)
//        
//        let secondSphereGeometry = SCNSphere(radius: 0.5)
//        let secondSphereNode = SCNNode(geometry: secondSphereGeometry)
//        secondSphereNode.position = SCNVector3(x: 3.0, y: 0.0, z: 0.0)
//        self.rootNode.addChildNode(secondSphereNode)
//        geometryLabel.text = "Atoms\n"
        let geometryNode = Scene.allAtoms()
        self.rootNode.addChildNode(geometryNode)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLights() {
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        self.rootNode.addChildNode(ambientLightNode)
        
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLight.LightType.omni
        omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 50, 50)
        self.rootNode.addChildNode(omniLightNode)
    }
    
    class func carbonAtom() -> SCNGeometry {
        
        let carbonAtom = SCNSphere(radius: 1.70)
        carbonAtom.firstMaterial!.diffuse.contents = UIColor.darkGray
        carbonAtom.firstMaterial!.specular.contents = UIColor.white
        return carbonAtom
    }
    
    class func hydrogenAtom() -> SCNGeometry {
        let hydrogenAtom = SCNSphere(radius: 1.20)
        hydrogenAtom.firstMaterial!.diffuse.contents = UIColor.lightGray
        hydrogenAtom.firstMaterial!.specular.contents = UIColor.white
        return hydrogenAtom
    }
    
    class func oxygenAtom() -> SCNGeometry {
        let oxygenAtom = SCNSphere(radius: 1.52)
        oxygenAtom.firstMaterial!.diffuse.contents = UIColor.red
        oxygenAtom.firstMaterial!.specular.contents = UIColor.white
        return oxygenAtom
    }
    
    class func fluorineAtom() -> SCNGeometry {
        let fluorineAtom = SCNSphere(radius: 1.47)
        fluorineAtom.firstMaterial!.diffuse.contents = UIColor.yellow
        fluorineAtom.firstMaterial!.specular.contents = UIColor.white
        return fluorineAtom
    }
    
    class func allAtoms() -> SCNNode {
        let atomsNode = SCNNode()
        
        let carbonNode = SCNNode(geometry: carbonAtom())
        carbonNode.position = SCNVector3Make(-6, 0, 0)
        atomsNode.addChildNode(carbonNode)
        
        let hydrogenNode = SCNNode(geometry: hydrogenAtom())
        hydrogenNode.position = SCNVector3Make(-2, 0, 0)
        atomsNode.addChildNode(hydrogenNode)
        
        let oxygenNode = SCNNode(geometry: oxygenAtom())
        oxygenNode.position = SCNVector3Make(+2, 0, 0)
        atomsNode.addChildNode(oxygenNode)
        
        let fluorineNode = SCNNode(geometry: fluorineAtom())
        fluorineNode.position = SCNVector3Make(+6, 0, 0)
        atomsNode.addChildNode(fluorineNode)
        
        return atomsNode
    }
}


