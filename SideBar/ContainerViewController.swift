import UIKit

class ContainerViewController: UIViewController {
    
    enum SlideOutState {
        case bothCollapsed
        case leftPanelExpanded
        case rightPanelExpanded
    }
    
    var centerViewController: CenterViewController!
    var centerNavigationController: UINavigationController!
    var leftViewController: SidePanelViewController?
    var rightViewController: SidePanelViewController?
    
    private var currentState: SlideOutState = .bothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .bothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    
    private let centerPanelExpandedOffset: CGFloat = 60
    
    public convenience init(centerVC: CenterViewController, navigationController: UINavigationController) {
        
        self.init()
        centerViewController = centerVC
        centerNavigationController = navigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        guard let centerViewController = centerViewController else {
            assertionFailure("You MUST provide center view controller")
            return
        }
        
        guard let centerNavigationController = self.centerNavigationController else {
            assertionFailure("You MUST provide center navigation view controller")
            return
        }
        
        centerViewController.delegate = self
        
        centerNavigationController.viewControllers = [centerViewController]
    
        view.addSubview(centerNavigationController.view)
        addChild(centerNavigationController)
        
        centerNavigationController.didMove(toParent: self)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
    }
}

// MARK: CenterViewController protocol

extension ContainerViewController: ContainerControllerProtocol {
    
    private func configureLeftPanelViewController() -> SidePanelViewController {
        
        let vc = SidePanelViewController()

        var menuItems = [SideMenuItem]()
        
        for n in 0...10 {
            menuItems.append(SideMenuItem(title: String.init(format: "%i", n)))
        }
        
        vc.menuItems = menuItems
        vc.view.backgroundColor = UIColor.green
        vc.view.frame.size.width -= centerPanelExpandedOffset

        return vc
    }
    
    private func configureRightPanelViewController() -> SidePanelViewController {
        
        let vc = SidePanelViewController()
        
        var menuItems = [SideMenuItem]()
        
        for n in 0...10 {
            menuItems.append(SideMenuItem(title: String.init(format: "%i", n)))
        }
        
        vc.menuItems = menuItems
        vc.view.backgroundColor = UIColor.blue
        vc.view.frame.size.width -= centerPanelExpandedOffset
        vc.view.frame.origin.x += centerPanelExpandedOffset
        
        return vc
    }
}

// MARK: CenterViewController delegate

extension ContainerViewController: CenterViewControllerDelegate {
    
    public func toggleLeftPanel() {
        
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    public func toggleRightPanel() {
        
        let notAlreadyExpanded = (currentState != .rightPanelExpanded)
        
        if notAlreadyExpanded {
            addRightPanelViewController()
        }
        
        animateRightPanel(shouldExpand: notAlreadyExpanded)
    }
    
    public func collapseSidePanels() {
        
        switch currentState {
        case .rightPanelExpanded:
            toggleRightPanel()
        case .leftPanelExpanded:
            toggleLeftPanel()
        default:
            break
        }
    }

    func addLeftPanelViewController() {
        
        guard leftViewController == nil else { return }
        
        leftViewController = configureLeftPanelViewController()
        
        if let leftViewController = leftViewController {
            addChildSidePanelController(leftViewController)
        }
    }
    
    func addRightPanelViewController() {
        
        guard rightViewController == nil else { return }
        
        rightViewController = configureRightPanelViewController()
        
        if let rightViewController = rightViewController {
            addChildSidePanelController(rightViewController)
        }
    }
    
    private func addChildSidePanelController(_ sidePanelController: SidePanelViewController) {
        
        sidePanelController.delegate = centerViewController
        view.insertSubview(sidePanelController.view, at: 0)
        
        addChild(sidePanelController)
        sidePanelController.didMove(toParent: self)
    }
    
    private func animateLeftPanel(shouldExpand: Bool) {
        
        if shouldExpand {
            currentState = .leftPanelExpanded
            animateCenterPanelXPosition(targetPosition: centerNavigationController.view.frame.width - centerPanelExpandedOffset)
            
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .bothCollapsed
                self.leftViewController?.view.removeFromSuperview()
                self.leftViewController = nil
            }
        }
    }
    
    private func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    private func animateRightPanel(shouldExpand: Bool) {
        
        if shouldExpand {
            currentState = .rightPanelExpanded
            animateCenterPanelXPosition(targetPosition: -centerNavigationController.view.frame.width + centerPanelExpandedOffset)
            
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .bothCollapsed
                self.rightViewController?.view.removeFromSuperview()
                self.rightViewController = nil
            }
        }
    }
    
    private func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        if shouldShowShadow {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
}

// MARK: Gesture recognizer

extension ContainerViewController: UIGestureRecognizerDelegate {
    
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
        
        switch recognizer.state {
            
        case .began:
            if currentState == .bothCollapsed {
                if gestureIsDraggingFromLeftToRight {
                    addLeftPanelViewController()
                } else {
                    addRightPanelViewController()
                }
                
                showShadowForCenterViewController(true)
            }
            
        case .changed:
            if let rview = recognizer.view {
                rview.center.x = rview.center.x + recognizer.translation(in: view).x
                recognizer.setTranslation(CGPoint.zero, in: view)
            }
            
        case .ended:
            if let _ = leftViewController,
                let rview = recognizer.view {
                let hasMovedGreaterThanHalfway = rview.center.x > view.bounds.size.width
                animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
                
            }
            if let _ = rightViewController,
                let rview = recognizer.view {
                let hasMovedGreaterThanHalfway = rview.center.x < 0
                animateRightPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
            
        default:
            break
        }
    }
}
