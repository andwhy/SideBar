import UIKit

struct SideMenuItem {
    var title: String?
    
    init(title: String) {
        self.title = title
    }
}

class SidePanelViewController: UIViewController {
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        PlainSidePanelTableViewCell.register(in: tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var delegate: SidePanelViewControllerDelegate?
    
    var menuItems: Array<SideMenuItem>!
    
    enum CellIdentifiers {
        static let PlainSidePanelTableViewCell = "PlainSidePanelTableViewCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
                
        tableView.reloadData()
    }
}

// MARK: Table View Data Source

extension SidePanelViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.PlainSidePanelTableViewCell, for: indexPath) as! PlainSidePanelTableViewCell
        
        let menuItem = menuItems[indexPath.row]
        
        cell.setTitle(menuItem.title)
        return cell
    }
}

// Mark: Table View Delegate

extension SidePanelViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRowAt(indexPath.row)
    }
}
