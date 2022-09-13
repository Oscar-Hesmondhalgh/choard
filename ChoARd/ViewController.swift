//
//  ViewController.swift
//  ChoARd
//
//  Created by Cain McCormack on 13/09/2022.
//

import UIKit
import RealityKit
import ARKit
import SpriteKit

class ViewController: UIViewController {
    @IBOutlet var scnView: ARSCNView!
    var boxAnchor: Experience.Box?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the "Box" scene from the "Experience" Reality File
//        boxAnchor = try! Experience.loadBox()

        scnView.delegate = self

//        arView.automaticallyConfigureSession = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let configuration = ARWorldTrackingConfiguration()
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else {
            return
        }
        configuration.frameSemantics.insert(.personSegmentationWithDepth)
        configuration.detectionObjects = ARReferenceObject.referenceObjects(inGroupNamed: "Models", bundle: nil)!
        // configuration.planeDetection = .horizontal
        scnView.session.run(configuration)
        // arView.scene.anchors.append(boxAnchor!)


    }
}

extension ViewController: ARSessionDelegate, ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {

        let node = SCNNode()

        if let objectAnchor = anchor as? ARObjectAnchor {

            print("detected in renderer")
            let plane = SCNPlane(width: CGFloat(objectAnchor.referenceObject.extent.x / 2), height: CGFloat(objectAnchor.referenceObject.extent.z / 17))

            // plane.cornerRadius = plane.width / 8

            let spriteKitScene = SKLabelNode(text: "👾")

            plane.firstMaterial?.diffuse.contents = spriteKitScene
            plane.firstMaterial?.isDoubleSided = true
            // plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)

            let planeNode = SCNNode(geometry: plane)
            planeNode.position = SCNVector3Make(objectAnchor.referenceObject.center.x, objectAnchor.referenceObject.center.y, objectAnchor.referenceObject.center.z)
            planeNode.rotation = SCNVector4Make(1, 0, 0, .pi * 0.5);


            node.addChildNode(planeNode)

        }

        return node
    }
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
//        if anchors[0].name == "Scan_09-44-24" {
//            guard let object = anchors[0] as? ARObjectAnchor else { return }
//
//        }
    }

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
    }
}

