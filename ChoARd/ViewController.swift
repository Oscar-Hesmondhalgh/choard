import UIKit
import RealityKit
import ARKit
import SpriteKit

class ViewController: UIViewController {
    @IBOutlet var scnView: ARSCNView!
    var boxAnchor: Experience.Box?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scnView.delegate = self
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
    }
}

extension ViewController: ARSessionDelegate, ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()

        if let objectAnchor = anchor as? ARObjectAnchor {
            print("detected in renderer")
            let planeNodes = getKeyPlanes(objectAnchor);

            let selectedNotes = ["C1", "E1" , "G1"]

            for planeNode in planeNodes {
                node.addChildNode(planeNode)

                let selected = selectedNotes.contains(planeNode.name!)
                planeNode.opacity = selected ? 1 : 0.3
                planeNode.geometry?.firstMaterial?.diffuse.contents = selected ? UIColor.red : UIColor.white
            }
        }

        return node
    }

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
//        if anchors[0].name == "Scan_09-44-24" {
//            guard let object = anchors[0] as? ARObjectAnchor else { return }
//
//        }
    }

    func getKeyPlanes(_ objectAnchor: ARObjectAnchor) -> [SCNNode] {

        let whiteNotes = ["C", "D", "E", "F", "G", "A", "B"]
        var planeNodes = [SCNNode]()
        let keyWidth = objectAnchor.referenceObject.extent.z / 17
        let keyHeight = objectAnchor.referenceObject.extent.x / 2.8
        let keyHeightOffset = objectAnchor.referenceObject.extent.x / 5
        let keyGap = keyWidth * 0.1
        let keySize = keyWidth - keyGap

        for key in -7...7 {
            let indexes = (key + 7).quotientAndRemainder(dividingBy: 7)

            let plane = SCNPlane(width: CGFloat(keyHeight), height: CGFloat(keySize))
            plane.firstMaterial?.isDoubleSided = true
            let planeNode = SCNNode(geometry: plane)
            print(whiteNotes[indexes.remainder] + "\(indexes.quotient)")
            planeNode.name = whiteNotes[indexes.remainder] + "\(indexes.quotient)"
            planeNode.position = SCNVector3Make(objectAnchor.referenceObject.center.x, objectAnchor.referenceObject.center.y - keyHeightOffset, objectAnchor.referenceObject.center.z - (keyWidth * Float(CGFloat(key))))
            planeNode.rotation = SCNVector4Make(1, 0, 0, .pi * 0.5);
            planeNodes.append(planeNode)
        }

        // planeNodes.reverse() //hack
        return planeNodes
    }
}

