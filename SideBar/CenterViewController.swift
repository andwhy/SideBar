import UIKit

class CenterViewController: UIViewController {

    var delegate: CenterViewControllerDelegate?
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"

        return label
    }()
    
    //MARK:Lifecycle
    
    override func viewDidLoad() {
        
        let leftButton = UIBarButtonItem(title: "=", style: .plain, target: self, action: #selector(leftButtonTapped(_:)))
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(title: "=", style: .plain, target: self, action: #selector(rightButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem  = rightButton
        
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
    }
    

    
    // MARK: Button actions
    @objc func leftButtonTapped(_ sender: Any) {
        delegate?.toggleLeftPanel?()
    }
    
    @objc func rightButtonTapped(_ sender: Any) {
        delegate?.toggleRightPanel?()
    }
}

// MARK: - SidePanelViewControllerDelegate
extension CenterViewController: SidePanelViewControllerDelegate {

    func didSelectRowAt(_ rowNumber: Int) {
        
        label.text = "\(rowNumber)"
        
        delegate?.collapseSidePanels?()
    }
}
