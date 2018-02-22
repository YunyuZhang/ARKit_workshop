//
//  ViewController.swift
//  ARKit_workshop
//
//  Created by Forrest on 2/18/18.
//  Copyright © 2018 Forrest. All rights reserved.
//Yoda project

import UIKit
import SceneKit
import ARKit


class ViewController: UIViewController,ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.debugOptions = [ ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        
        
        // Run the view's session
        sceneView.session.run(configuration)
        registerGestureRecognizers()
        
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/Yoda.scn")!
    
        
        // Set the scene to the view
        sceneView.scene = scene
       
    }
    
    func registerGestureRecognizers() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        
    }
    
    @objc func tapped(sender: UITapGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let tapLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        if !hitTest.isEmpty {
            self.addItem(hitTestResult: hitTest.first!)
        }
    }
    
    func addItem(hitTestResult: ARHitTestResult) {
        
        let scene = SCNScene(named: "art.scnassets/Yoda.scn")
        
        let node = (scene?.rootNode.childNode(withName:"Yoda", recursively: false))!
        
        let transform = hitTestResult.worldTransform
        let thirdColumn = transform.columns.3
        //make the node be placed on point where we tapped
        node.position = SCNVector3(thirdColumn.x, thirdColumn.y+0.2, thirdColumn.z)
        // make Yode facing me
        node.eulerAngles = SCNVector3(0,0,0)
        
        self.sceneView.scene.rootNode.addChildNode(node)
        
        let source = SCNAudioSource(fileNamed: "art.scnassets/Jedis_strength.mp3")
        let action = SCNAction.playAudio(source!, waitForCompletion: true)
        node.runAction(action)
        
        
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let ARAnchorNode = SCNNode()
        //create the plane node
        let planeNode = SCNNode()
        
        
        //convert the Anchor to an ARPlaneAnchor to ge t access to ARPlaneAnchor's extent and center values
        let anchor = anchor as? ARPlaneAnchor
        planeNode.geometry = SCNPlane(width: CGFloat((anchor?.extent.x)!), height:CGFloat((anchor?.extent.z)!))
        //place the plane in the center of the anchor
        planeNode.position = SCNVector3((anchor?.center.x)!,0, (anchor?.center.z)!)
        planeNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named:"art.scnassets/concrete")
        //rotate the plane use euler angle
        planeNode.eulerAngles = SCNVector3(-Float.pi/2,-Float.pi/2,0)
        
        
        // add the plane to the anchor
        ARAnchorNode.addChildNode(planeNode)
        
        return ARAnchorNode
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        let anchor = anchor as? ARPlaneAnchor
        let planeNode = node.childNodes.first
        
        planeNode?.geometry = SCNPlane(width: CGFloat((anchor?.extent.x)!), height:CGFloat((anchor?.extent.z)!))
        //place the plane in the center of the anchor
        planeNode?.position = SCNVector3((anchor?.center.x)!,0, (anchor?.center.z)!)
        planeNode?.geometry?.firstMaterial?.diffuse.contents = UIImage(named:"art.scnassets/concrete")
        
    }
    
    



}

