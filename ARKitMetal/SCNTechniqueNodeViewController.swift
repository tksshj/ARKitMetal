import UIKit
import ARKit


class SCNTechniqueNodeViewController: UIViewController, ARSCNViewDelegate {


  var faceGeometry: ARSCNFaceGeometry!
  var faceNode: SCNNode!


  override func viewDidLoad() {
    super.viewDidLoad()

    guard ARFaceTrackingConfiguration.isSupported else { return }

    let scnView = ARSCNView(frame: self.view.bounds)
    self.view.addSubview(scnView)

    guard let device = scnView.device else {return}
    faceGeometry = ARSCNFaceGeometry(device: device)
    faceNode = SCNNode(geometry: faceGeometry)
    faceNode.categoryBitMask = 2

    let configuration = ARFaceTrackingConfiguration()

    scnView.delegate = self
    scnView.showsStatistics = true
    scnView.session.run(configuration)

    if let path = Bundle.main.path(forResource: "SCNTechniqueNode", ofType: "json") {
      if let data = NSData(contentsOfFile: path) as Data? {
        if let dictionary = try! JSONSerialization.jsonObject(with: data) as? [String: AnyObject] {
          let technique = SCNTechnique(dictionary: dictionary)
          scnView.technique = technique
        }
      }
    }
  }


  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard let faceAnchor = anchor as? ARFaceAnchor else {return}
    faceGeometry.update(from: faceAnchor.geometry)
    node.addChildNode(faceNode)
  }


  func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
    guard let faceAnchor = anchor as? ARFaceAnchor else {return}
    faceGeometry.update(from: faceAnchor.geometry)
  }
}
