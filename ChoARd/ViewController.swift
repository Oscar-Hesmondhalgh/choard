//
//  ViewController.swift
//  ChoARd
//
//  Created by Cain McCormack on 13/09/2022.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController {
    @IBOutlet var arView: ARView!
    var boxAnchor: Experience.Box?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the "Box" scene from the "Experience" Reality File
//        boxAnchor = try! Experience.loadBox()

        arView.session.delegate = self
        arView.automaticallyConfigureSession = false
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
        arView.session.run(configuration)
        // arView.scene.anchors.append(boxAnchor!)


    }
}

extension ViewController: ARSessionDelegate {
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        if anchors[0].name == "Scan_09-44-24" {
            guard let object = anchors[0] as? ARObjectAnchor else { return }

            // let transform = object.transform
            let extent = object.referenceObject.extent

            // Create a transform with a translation of 0.2 meters in front of the camera.
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.2
            let transform = simd_mul(arView.session.currentFrame!.camera.transform , translation)


            // Add a new anchor to the session.
            let anchor = ARAnchor(transform: transform)
            arView.session.add(anchor: anchor)
//            boxAnchor?.setTransformMatrix(transform, relativeTo: nil)
//            boxAnchor?.setScale(extent, relativeTo: nil)
//            arView.scene.anchors.append(boxAnchor!)

            print("added box")
        }
    }

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
    }
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        return SKLabelNode(text: "👾")
    }
}

