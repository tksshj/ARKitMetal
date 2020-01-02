import UIKit
import ARKit


class SCNTechniqueViewController: UIViewController {


  override func viewDidLoad() {
    super.viewDidLoad()

    guard ARFaceTrackingConfiguration.isSupported else { return }

    let scnView = ARSCNView(frame: self.view.bounds)
    scnView.showsStatistics = true
    self.view.addSubview(scnView)

    let configuration = ARFaceTrackingConfiguration()
    scnView.session.run(configuration)

    if let path = Bundle.main.path(forResource: "SCNTechnique", ofType: "json") {
      if let data = NSData(contentsOfFile: path) as Data? {
        if let dictionary = try! JSONSerialization.jsonObject(with: data) as? [String: AnyObject] {
          let technique = SCNTechnique(dictionary: dictionary)
          scnView.technique = technique
        }
      }
    }
  }
}
