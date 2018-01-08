//
//  ARViewViewController.swift
//  ARKitDemo
//
//  Created by Vincent Villalta on 1/8/18.
//  Copyright © 2018 Vincent Villalta. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARViewViewController: UIViewController, ARSCNViewDelegate {
    
    // MARK: - Variables
    @IBOutlet var sceneView: ARSCNView!
    var nodeModel:SCNNode!
    
    
    // MARK: - ViewController Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.antialiasingMode = .multisampling4X
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        self.configureLighting()
        self.addModelObject()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    
    // MARK: - View Controller Interaction
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touchLocation = touches.first!.location(in: sceneView)
        
        var hitOptions = [SCNHitTestOption: Any]()
        hitOptions[SCNHitTestOption.boundingBoxOnly] = true
        
        let hitResults: [SCNHitTestResult]  = sceneView.hitTest(touchLocation, options: hitOptions)
        
        if let hit = hitResults.first {
            if let node = getParent(hit.node) {
                node.removeFromParentNode()
                return
            }
        }
        
        let hitResultsPoints: [ARHitTestResult]  = sceneView.hitTest(touchLocation, types: .featurePoint)
        if let hit = hitResultsPoints.first {
            let rotate = simd_float4x4(SCNMatrix4MakeRotation(sceneView.session.currentFrame!.camera.eulerAngles.y, 0, 1, 0))
            let final = simd_mul(hit.worldTransform, rotate)
            sceneView.session.add(anchor: ARAnchor(transform: final))
        }
        
    }
    
    func getParent(_ nodeFound: SCNNode?) -> SCNNode? {
        if let node = nodeFound {
            if node.name == "cherub" {
                return node
            } else if let parent = node.parent {
                return getParent(parent)
            }
        }
        return nil
    }
    
    
    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if !anchor.isKind(of: ARPlaneAnchor.self) {
            DispatchQueue.main.async {
                let modelClone = self.nodeModel.clone()
                modelClone.position = SCNVector3Zero
                node.addChildNode(modelClone)
            }
        }
    }
    
    func addModelObject(x: Float = 0, y: Float = 0, z: Float = -0.5) {
        guard let objectScene = SCNScene(named: "art.scnassets/cherub.dae"), let objectNode = objectScene.rootNode.childNode(withName: "cherub", recursively: true) else { return }
        objectNode.position = SCNVector3(x, y, z)
        nodeModel = objectNode
        sceneView.scene.rootNode.addChildNode(objectNode)
    }
    
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }

    
    // MARK: - Actions
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
