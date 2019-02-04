//
//  AppDelegate.swift
//  SideBar
//
//  Created by Rozhkov, Andrey on 31/01/2019.
//  Copyright © 2019 Rozhkov, Andrey. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let centerVC = CenterViewController()
        centerVC.view.backgroundColor = UIColor.white
        
        let navigationController = UINavigationController()
        let leftVC = SidePanelViewController()
        leftVC.view.backgroundColor = UIColor.green

        let rightVC = SidePanelViewController()
        rightVC.view.backgroundColor = UIColor.blue
        
        let containerViewController = ContainerViewController(centerVC: centerVC, navigationController: navigationController, leftVC: leftVC, rightVC: rightVC)
        
        window!.rootViewController = containerViewController
        window!.makeKeyAndVisible()

        return true
    }

}

