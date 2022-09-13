import UIKit
import RealityKit
import ARKit
import SpriteKit

class ViewController: UIViewController {
    @IBOutlet var scnView: ARSCNView!
    var keyNodes = [SCNNode]()
    var selectedNotes = ["C1", "E1" , "G1"]
    
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
        scnView.session.run(configuration)
    }
}

extension ViewController: ARSessionDelegate, ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()

        if let objectAnchor = anchor as? ARObjectAnchor {
            print("detected in renderer")
            keyNodes = getKeyPlanes(objectAnchor)
            updateKeyProperties()
            for keyNode in keyNodes {
                node.addChildNode(keyNode)
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

    func updateKeyProperties() {
        for keyNode in keyNodes {
            let selected = selectedNotes.contains(keyNode.name!)
            let blackNote = keyNode.name!.contains("#")
            let offColor = blackNote ? UIColor.black : UIColor.white
            let offOpacity = blackNote ? 0.6 : 0.3
            keyNode.opacity = selected ? 0.8 : offOpacity
            keyNode.geometry?.firstMaterial?.diffuse.contents = selected ? UIColor.blue : offColor
        }
    }

    func getKeyPlanes(_ objectAnchor: ARObjectAnchor) -> [SCNNode] {

        let whiteNotes = ["C", "D", "E", "F", "G", "A", "B"]
        let blackNotes = ["C", "D", "F", "G", "A"]
        var planeNodes = [SCNNode]()
        let whiteKeySpace = objectAnchor.referenceObject.extent.z / 17
        let whiteKeyHeight = objectAnchor.referenceObject.extent.x / 2.8
        let whiteKeyHeightOffset = objectAnchor.referenceObject.extent.x / 18
        let whiteKeyGap = whiteKeySpace * 0.1
        let whiteKeyWidth = whiteKeySpace - whiteKeyGap

        let blackKeyWidth = whiteKeyWidth / 1.7
        let blackKeyHeight = whiteKeyHeight / 1.7

        for key in -7...7 {
            let indexes = (key + 7).quotientAndRemainder(dividingBy: 7)

            let noteLetter = whiteNotes[indexes.remainder]
            let noteOctave = indexes.quotient
            let plane = SCNPlane(width: CGFloat(whiteKeyHeight), height: CGFloat(whiteKeyWidth))
            plane.firstMaterial?.isDoubleSided = true
            let whiteNode = SCNNode(geometry: plane)
            whiteNode.name = noteLetter + "\(noteOctave)"
            whiteNode.position = SCNVector3Make(objectAnchor.referenceObject.center.x + whiteKeyHeightOffset, objectAnchor.referenceObject.center.y, objectAnchor.referenceObject.center.z - (whiteKeySpace * Float(CGFloat(key))))
            whiteNode.rotation = SCNVector4Make(1, 0, 0, .pi * 0.5);
            planeNodes.append(whiteNode)

            if (blackNotes.contains(noteLetter) && (noteOctave != 2)) {
                let blackPlane = SCNPlane(width: CGFloat(blackKeyHeight), height: CGFloat(blackKeyWidth))
                blackPlane.firstMaterial?.isDoubleSided = true
                let blackNode = SCNNode(geometry: blackPlane)

                blackNode.name = noteLetter + "#\(noteOctave)"
                blackNode.position = SCNVector3Make(whiteNode.position.x - 0.02, whiteNode.position.y  + 0.005, whiteNode.position.z - (whiteKeySpace / 2))
                blackNode.rotation = whiteNode.rotation
                planeNodes.append(blackNode)
            }

        }

        // planeNodes.reverse() //hack
        return planeNodes
    }
}

