//
//  MainTableViewCell.swift
//  SeSACShopping
//
//  Created by Seryun Chun on 2024/01/21.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet var searchIconImageView: UIImageView!
    @IBOutlet var recentSearchLabel: UILabel!
    @IBOutlet var deleteButton: UIButton!
    
    func configureMainCell(_ recentKeyword: String) {
        searchIconImageView.image = Images.search
        searchIconImageView.tintColor = .white
        
        recentSearchLabel.text = recentKeyword
        recentSearchLabel.font = Fonts.r14
        recentSearchLabel.textColor = .white
        
        deleteButton.setTitle(nil, for: .normal)
        deleteButton.setImage(Images.delete, for: .normal)
        deleteButton.tintColor = .white
    }
}
