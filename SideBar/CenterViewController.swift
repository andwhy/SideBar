import UIKit

class CenterViewController: UIViewController {

    var delegate: CenterViewControllerDelegate?
    
    //MARK:Lifecycle
    
    override func viewDidLoad() {
        
        let leftButton = UIBarButtonItem(title: "=", style: .plain, target: self, action: #selector(leftButtonTapped(_:)))
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(title: "=", style: .plain, target: self, action: #selector(rightButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem  = rightButton
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
        print("row number - \(rowNumber)")
        
        delegate?.collapseSidePanels?()
    }
}
