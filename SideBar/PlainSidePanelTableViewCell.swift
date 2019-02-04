//
//  PlainSidePanelTableViewCell.swift
//  SideBar
//
//  Created by Rozhkov, Andrey on 01/02/2019.
//  Copyright © 2019 Rozhkov, Andrey. All rights reserved.
//

import UIKit

class PlainSidePanelTableViewCell: UITableViewCell, CellRegisterable {

    @IBOutlet private weak var labelTitle: UILabel!
    
    public func setTitle(_ title: String?) {
        
        guard let title = title else {
            labelTitle.text = ""
            return
        }
        
        labelTitle.text = title
    }
}


