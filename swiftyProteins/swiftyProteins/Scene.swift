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

    let conects : [[(x: Float, y: Float, z: Float, type: String)]]
    var atoms : [(x: Float, y: Float, z: Float, type: String)]
    
    init(atoms : [(x: Float, y: Float, z: Float, type: String)], conects : [[(x: Float, y: Float, z: Float, type: String)]]) {
        self.atoms = atoms
        self.conects = conects
        super.init()
        setupCamera()
//        setupLights()
        self.rootNode.addChildNode(allAtoms())
        self.rootNode.addChildNode(allConects())
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCamera() {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 30)
        self.rootNode.addChildNode(cameraNode)
    }
    
    func setupLights() {
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
    
    func atomGeometry(type : String) -> SCNGeometry {
        var radius : CGFloat
        var diffuseColor : UIColor
        let factor : CGFloat = 0.1
        
        switch type {
        case "H" :
            radius = 1.20 * factor
            diffuseColor = UIColor.white
        case "B" :
            radius = 1.50 * factor //arbitrary
            diffuseColor = UIColor(red:1.00, green:0.67, blue:0.47, alpha:1.0)
        case "C" :
            radius = 1.70 * factor
            diffuseColor = UIColor.black
        case "N" :
            radius = 1.55 * factor
            diffuseColor = UIColor.blue
        case "O" :
            radius = 1.52 * factor
            diffuseColor = UIColor.red
        case "F" :
            radius = 1.47 * factor
            diffuseColor = UIColor.green
        case "P" :
            radius = 1.80 * factor
            diffuseColor = UIColor.orange
        case "S" :
            radius = 1.80 * factor
            diffuseColor = UIColor.yellow
        case "CL" :
            radius = 1.75 * factor
            diffuseColor = UIColor.green
        case "BR" :
            radius = 1.85 * factor
            diffuseColor = UIColor(red:0.60, green:0.13, blue:0.00, alpha:1.0)
        default :
            radius = 2.00 * factor
            diffuseColor = UIColor.magenta
        }
        
        let atom = SCNSphere(radius: radius)
        atom.firstMaterial!.diffuse.contents = diffuseColor
        atom.firstMaterial!.specular.contents = UIColor.white
        return atom
    }
    
    func allAtoms() -> SCNNode {
        let atomsNode = SCNNode()
        
        for atom in self.atoms {
            let node = SCNNode(geometry: atomGeometry(type: atom.type))
            node.position = SCNVector3Make(atom.x, atom.y, atom.z)
            node.name = atom.type
            atomsNode.addChildNode(node)
        }
        
        return atomsNode
    }
    
    func conectGeometry(p1: (x: Float, y: Float, z: Float, type: String), p2: (x: Float, y: Float, z: Float, type: String)) -> SCNGeometry {

        let v1 : SCNVector3 = SCNVector3Make(p1.x, p1.y, p1.z)
        let v2 : SCNVector3 = SCNVector3Make(p2.x, p2.y, p2.z)
        let radius : CGFloat = 0.1 //
        let height = v1.distance(receiver: v2)
        print(height)//
        let conect = SCNCylinder(radius: radius, height: CGFloat(height))
        conect.radialSegmentCount = 10 //
        conect.firstMaterial?.diffuse.contents = UIColor.black //
        return conect
    }
    
    func allConects() -> SCNNode {
        let conectsNode = SCNNode()
        
        for conect in self.conects {

            let v0 : SCNVector3 = SCNVector3Make(conect[0].x, conect[0].y, conect[0].z)
            let v1 : SCNVector3 = SCNVector3Make(conect[1].x, conect[1].y, conect[1].z)
            let radius : CGFloat = 0.01 //
            let height = v0.distance(receiver: v1)
            let geometry = SCNCylinder(radius: radius, height: CGFloat(height))
            geometry.radialSegmentCount = 10 //
            geometry.firstMaterial?.diffuse.contents = UIColor.black //
            
            let cylinderline = SCNNode()
            cylinderline.position = v0
            let node1 = SCNNode()
            node1.position = v1
            conectsNode.addChildNode(node1)
            
            let zAlign = SCNNode()
            zAlign.eulerAngles.x = Float(M_PI_2)
            
            let node = SCNNode(geometry: geometry)
            node.position.y = -height / 2
            zAlign.addChildNode(node)
            cylinderline.addChildNode(zAlign)
            cylinderline.constraints = [SCNLookAtConstraint(target: node1)]
            
            conectsNode.addChildNode(cylinderline)
        }
        
        return conectsNode
    }
    
}

private extension SCNVector3 {
    func distance(receiver:SCNVector3) -> Float{
        let xd = receiver.x - self.x
        let yd = receiver.y - self.y
        let zd = receiver.z - self.z
        return fabs(Float(sqrt(xd * xd + yd * yd + zd * zd)))
    }
}
