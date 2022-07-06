//
//  TournamentTableCell.swift
//  CoreDataTest
//
//  Created by Amine Ben Jemia on 7/4/22.
//

import UIKit

class TournamentTableCell: UITableViewCell {

    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    static let identifier = "Tournament Cell"
    
    func setupCell() {
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        countryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
    }
    
}
