import UIKit
import ARKit


class SCNTechniqueUniformViewController: UIViewController, ARSCNViewDelegate {


  var scnView: ARSCNView!


  override func viewDidLoad() {
    super.viewDidLoad()

    guard ARFaceTrackingConfiguration.isSupported else {return}

    scnView = ARSCNView(frame: self.view.bounds)
    scnView.delegate = self
    scnView.showsStatistics = true
    self.view.addSubview(scnView)

    let configuration = ARFaceTrackingConfiguration()
    scnView.session.run(configuration)

    if let path = Bundle.main.path(forResource: "SCNTechniqueUniform", ofType: "json") {
      if let data = NSData(contentsOfFile: path) as Data? {
        if let dictionary = try! JSONSerialization.jsonObject(with: data) as? [String: AnyObject] {
          let technique = SCNTechnique(dictionary: dictionary)
          scnView.technique = technique
        }
      }
    }

  }


  func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
    let data = NSNumber(value: 1.0)
    self.scnView.technique?.setObject(data, forKeyedSubscript: "symbolsSCNTechniqueUniform" as NSCopying)
  }
}
