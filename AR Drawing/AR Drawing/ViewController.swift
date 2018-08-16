//
//  ViewController.swift
//  AR Drawing
//
//  Created by octagon studio on 22/07/18.
//  Copyright © 2018 Cordova. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()

    @IBOutlet weak var draw: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.session.run(configuration)
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.showsStatistics = false //show information
        self.sceneView.delegate = self //to initiate render
        resetButton()
    }
    
    //Reset Session
    func resetButton(){
        let resetButton = UIButton(frame: CGRect(x: 280, y: 555, width: 80, height: 80))
        resetButton.backgroundColor = .red
        resetButton.setTitle("Reset", for : .normal)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.addTarget(self, action: #selector(onReset), for: .touchUpInside)
        
        self.view.addSubview(resetButton)
    }
    
    @objc func onReset(sender: UIButton!){
        self.resetSession()
    }
    
    func resetSession(){
        self.sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes {(node, _) in
            node.removeFromParentNode()
        }
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
 
    // Renderer to Draw a Scene
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        
        guard let startDrawing = sceneView.pointOfView else {return}
        
        let changingDrawingSequences = startDrawing.transform
        let orientation = SCNVector3(-changingDrawingSequences.m31, -changingDrawingSequences.m32, -changingDrawingSequences.m33)
        let location = SCNVector3(changingDrawingSequences.m41, changingDrawingSequences.m42, changingDrawingSequences.m43)
        let currentDrawingPosition = orientation + location
        
        DispatchQueue.main.async {
            if self.draw.isHighlighted {
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphereNode.position = currentDrawingPosition
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                
           
                
            } else {
                let pointer = SCNNode(geometry: SCNSphere(radius: 0.01))
                pointer.name = "pointer"
                pointer.position = currentDrawingPosition
                
                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                    if node.name == "pointer" {
                        node.removeFromParentNode()
                    }
                })
                
    
                self.sceneView.scene.rootNode.addChildNode(pointer)
                pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            }
        }
    }
    
}



3
