//
//  EmptyMainTableViewCell.swift
//  SeSACShopping
//
//  Created by Seryun Chun on 2024/01/21.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {

    @IBOutlet var emptyImageView: UIImageView!
    @IBOutlet var emptyLabel: UILabel!
    
    func configureEmptyCell() {
        emptyImageView.image = Images.empty
        emptyLabel.text = "최근 검색어가 없어요"
        emptyLabel.font = Fonts.b17
    }
}
