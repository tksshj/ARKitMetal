import UIKit


class RootViewController: UITableViewController {


  var sections: [Section] = []


  override func viewDidLoad() {
    super.viewDidLoad()
  }


  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.sections = self.createSections()
    self.tableView.reloadData()
  }


  // MARK: - Table view data source


  override func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }


  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sections[section].rows.count
  }


  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section].title
  }


  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let row = sections[indexPath.section].rows[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "rootViewCell", for: indexPath)
    cell.textLabel?.text = row.title
    cell.detailTextLabel?.text = row.subtitle
    return cell
  }


  // MARK: - UITableViewDelegate


  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let row = sections[indexPath.section].rows[indexPath.row]
    row.action()
  }


  func createSections() -> [Section] {
    return [
      Section(title: "SCNTechnique",
              rows: [
                Row(title: "SCNTechniqueViewController",
                    subtitle: "Use shaders with SCNTechnique",
                    action: {
                      let vc = SCNTechniqueViewController(nibName: nil, bundle: nil)
                      self.navigationController?.pushViewController(vc, animated: true)
                    }),
                Row(title: "SCNTechniqueUniformViewController",
                    subtitle: "Pass uniform variables to shaders in SCNTechnique",
                    action: {
                      let vc = SCNTechniqueUniformViewController(nibName: nil, bundle: nil)
                      self.navigationController?.pushViewController(vc, animated: true)
                    }),
                Row(title: "SCNTechniqueNodeViewController",
                    subtitle: "Add a node for a detected face and draw using Metal",
                    action: {
                      let vc = SCNTechniqueNodeViewController(nibName: nil, bundle: nil)
                      self.navigationController?.pushViewController(vc, animated: true)
                    })
              ]),
      Section(title: "SCNProgram",
              rows:[
                Row(title: "SCNProgramViewController",
                    subtitle: "Use shaders with SCNProgram",
                    action: {
                      let vc = SCNProgramViewController(nibName: nil, bundle: nil)
                      self.navigationController?.pushViewController(vc, animated: true)
                    }),
                Row(title: "SCNProgramFragmentViewController",
                    subtitle: "Move face using a fragment shader",
                    action: {
                      let vc = SCNProgramFragmentViewController(nibName: nil, bundle: nil)
                      self.navigationController?.pushViewController(vc, animated: true)
                    }),
              ])
    ]
  }
}
