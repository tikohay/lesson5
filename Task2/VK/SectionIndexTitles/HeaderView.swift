//
//  HeaderView.swift
//  VK
//
//  Created by Karahanyan Levon on 03.02.2021.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {

    @IBOutlet var headerLabel: UILabel? {
        didSet {
            headerLabel?.backgroundColor = #colorLiteral(red: 0.7960598469, green: 0.7960438132, blue: 0.800293982, alpha: 1)
        }
    }

}
