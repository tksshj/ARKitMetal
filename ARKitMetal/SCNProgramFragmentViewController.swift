import UIKit
import ARKit


class SCNProgramFragmentViewController: UIViewController, ARSCNViewDelegate {


  var scnView: ARSCNView!
  var viewportSize: CGSize!
  var faceGeometry: ARSCNFaceGeometry!
  var faceNode: SCNNode!


  override func viewDidLoad() {
    super.viewDidLoad()

    guard ARFaceTrackingConfiguration.isSupported else { return }

    scnView = ARSCNView(frame: self.view.bounds)
    self.view.addSubview(scnView)

    viewportSize = scnView.bounds.size

    guard let device = scnView.device else {return}
    faceGeometry = ARSCNFaceGeometry(device: device)
    faceNode = SCNNode(geometry: faceGeometry)


    let configuration = ARFaceTrackingConfiguration()

    scnView.delegate = self
    scnView.showsStatistics = true
    scnView.session.run(configuration)
  }


  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard let faceAnchor = anchor as? ARFaceAnchor else {return}
    faceGeometry.update(from: faceAnchor.geometry)
    node.addChildNode(faceNode)

    if let material = faceGeometry.firstMaterial {
      let program = SCNProgram()
      program.vertexFunctionName = "vertexShaderSCNProgramFragment"
      program.fragmentFunctionName = "fragmentShaderSCNProgramFragment"

      material.program = program

      guard let frame = scnView.session.currentFrame else {return}
      let affineTransform = frame.displayTransform(for: .portrait, viewportSize: viewportSize)
      let transform = SCNMatrix4(affineTransform)
      material.setValue(SCNMatrix4Invert(transform), forKey: "displayTransform")
    }
  }


  func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
    guard let faceAnchor = anchor as? ARFaceAnchor else {return}

    if let material = faceGeometry.firstMaterial,
       let contents = scnView.scene.background.contents
    {
      let imageProperty = SCNMaterialProperty(contents: contents)
      material.setValue(imageProperty, forKey: "colorSampler")
    }

    faceGeometry.update(from: faceAnchor.geometry)
  }
}
