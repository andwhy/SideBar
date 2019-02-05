//
//  ContainerControllerProtocol.swift
//  SideBar
//
//  Created by Rozhkov, Andrey on 05/02/2019.
//  Copyright © 2019 Rozhkov, Andrey. All rights reserved.
//

import Foundation

@objc
protocol ContainerControllerProtocol {
    
    @objc optional func configureLeftPanelViewController() -> SidePanelViewController
    @objc optional func configureRightPanelViewController() -> SidePanelViewController
}
