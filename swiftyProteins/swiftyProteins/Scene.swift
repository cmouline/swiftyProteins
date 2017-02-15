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
    let atoms : [(x: Float, y: Float, z: Float, type: String)]
    let sceneType : String
    let hydrogens : Bool
    
    init(atoms : [(x: Float, y: Float, z: Float, type: String)],
         conects : [[(x: Float, y: Float, z: Float, type: String)]],
         sceneType : String,
         hydrogens : Bool) {
        self.atoms = atoms
        self.conects = conects
        self.sceneType = sceneType
        self.hydrogens = hydrogens
        super.init()
        setupCamera()
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
    
    func diffuseColor(type : String) -> UIColor {
        switch type {
        case "H" :
            return UIColor.white
        case "B" :
            return UIColor(red:1.00, green:0.67, blue:0.47, alpha:1.0)
        case "C" :
            return sceneType == "modern" ? UIColor.black : UIColor.darkGray
        case "N" :
            return UIColor.blue
        case "O" :
            return UIColor.red
        case "F", "CL" :
            return UIColor.green
        case "P" :
            return UIColor.orange
        case "S" :
            return UIColor.yellow
        case "BR" :
            return UIColor(red:0.60, green:0.13, blue:0.00, alpha:1.0)
        default :
            return UIColor.magenta
        }
    }
    
    func vanDerWaals(type : String) -> CGFloat {
        switch type {
        case "H" :
            return 1.20
        case "C" :
            return 1.70
        case "N" :
            return 1.55
        case "O" :
            return 1.52
        case "F" :
            return 1.47
        case "P", "S" :
            return 1.80
        case "CL" :
            return 1.75
        case "BR" :
            return 1.85
        default :
            return 2.00
        }
    }
    
    func atomGeometry(type : String) -> SCNGeometry {
        var radius : CGFloat
        switch sceneType {
        case "classic":
            radius = 0.5
        case "modern":
            radius = vanDerWaals(type: type) * 0.1
        default:
            radius = 1
        }
        
        let atom = SCNSphere(radius: radius)
        atom.firstMaterial!.diffuse.contents = diffuseColor(type: type)
        atom.firstMaterial!.specular.contents = UIColor.white
        return atom
    }
    
    func allAtoms() -> SCNNode {
        let atomsNode = SCNNode()
        
        for atom in self.atoms {
            
            if hydrogens == false && atom.type == "H" {
                continue
            }
            
            let node = SCNNode(geometry: atomGeometry(type: atom.type))
            node.position = SCNVector3Make(atom.x, atom.y, atom.z)
            node.name = atom.type
            atomsNode.addChildNode(node)
        }
        
        return atomsNode
    }
    
    func allConects() -> SCNNode {
        let conectsNode = SCNNode()
        
        if sceneType != "compact" {
            for conect in self.conects {
                
                if hydrogens == false && (conect[0].type == "H" || conect[1].type == "H") {
                    continue
                }

                var v0 : SCNVector3 = SCNVector3Make(conect[0].x, conect[0].y, conect[0].z)
                var v1 : SCNVector3 = SCNVector3Make(conect[1].x, conect[1].y, conect[1].z)
                let height = v0.distance(receiver: v1)
                
                if sceneType == "modern" {
                    let radius : CGFloat = 0.01 //
                    if conect[0].x == conect[1].x && conect[0].y == conect[1].y && conect[0].z < conect[1].z {
                        swap(&v0, &v1)
                    }
                    let geometry = SCNCylinder(radius: radius, height: CGFloat(height))
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
                else {
                    let radius : CGFloat = 0.2 //
                    
                    let geometry0 : SCNGeometry = SCNCylinder(radius: radius, height: CGFloat(height / 2))
                    let geometry1 : SCNGeometry = SCNCylinder(radius: radius, height: CGFloat(height / 2))
                    
                    if conect[0].x == conect[1].x && conect[0].y == conect[1].y && conect[0].z < conect[1].z {
                            swap(&v0, &v1) //le pb sera donc toujours sur 1
                            geometry0.firstMaterial?.diffuse.contents = diffuseColor(type: conect[1].type)
                            geometry1.firstMaterial?.diffuse.contents = diffuseColor(type: conect[0].type)
                    }
                    else {
                            geometry0.firstMaterial?.diffuse.contents = diffuseColor(type: conect[0].type)
                            geometry1.firstMaterial?.diffuse.contents = diffuseColor(type: conect[1].type)
                    }

                    let cylinderline0 = SCNNode()
                    cylinderline0.position = v0
                    let node1 = SCNNode()
                    node1.position = v1
                    conectsNode.addChildNode(node1)
                    
                    let cylinderline1 = SCNNode()
                    let node0 = SCNNode()
                    if conect[0].x == conect[1].x && conect[0].y == conect[1].y {
                        cylinderline1.position = SCNVector3Make(conect[0].x, conect[0].y, (conect[0].z + conect[1].z) / 2)
                        node0.position = v1
                    }
                    else {
                        cylinderline1.position = v1
                        node0.position = v0

                    }
                    conectsNode.addChildNode(node0)
                    
                    let zAlign0 = SCNNode()
                    zAlign0.eulerAngles.x = Float(M_PI_2)
                    
                    let zAlign1 = SCNNode()
                    zAlign1.eulerAngles.x = Float(M_PI_2)
                    
                    let node00 = SCNNode(geometry: geometry0)
                    node00.position.y = -height / 4
                    zAlign0.addChildNode(node00)
                    cylinderline0.addChildNode(zAlign0)
                    cylinderline0.constraints = [SCNLookAtConstraint(target: node1)]
                    conectsNode.addChildNode(cylinderline0)
                    
                    let node11 = SCNNode(geometry: geometry1)
                    node11.position.y = -height / 4
                    zAlign1.addChildNode(node11)
                    cylinderline1.addChildNode(zAlign1)
                    cylinderline1.constraints = [SCNLookAtConstraint(target: node0)]
                    conectsNode.addChildNode(cylinderline1)
                }
            }
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
