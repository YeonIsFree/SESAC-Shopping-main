//
//  SearchResultCollectionViewCell.swift
//  SeSACShopping
//
//  Created by Seryun Chun on 2024/01/21.
//

import UIKit
import Alamofire
import Kingfisher

class SearchResultCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var resultImageView: UIImageView!
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    override func awakeFromNib() {
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    func configureSearchResultCell(itemList: [Item], index: Int) {
        let item: Item = itemList[index]
        
        if let imageUrl = URL(string: item.image) {
            resultImageView.kf.setImage(with: imageUrl)
        } else { return }
        
        let likeList = UserDefaultManager.shared.getLikeList()
        let likeButtonImage = likeList.contains(item.productId) ? Images.heartFill : Images.heart
        likeButton.setImage(likeButtonImage, for: .normal)
        
        companyLabel.text = item.mallName
        companyLabel.font = Fonts.r13
        
        titleLabel.text = item.title
        titleLabel.font = Fonts.r14
        titleLabel.numberOfLines = 2
        
        priceLabel.text = NumberFormatter.convertNumber(item.lprice)
        priceLabel.font = Fonts.b16
    }
    
    @objc func likeButtonTapped(sender: UIButton) {
        let likeList = UserDefaultManager.shared.getLikeList()
        let productId = "\(sender.tag)"
        let isLiked = likeList.contains(productId)
        if isLiked {
            UserDefaultManager.shared.removeLike(productId: productId)
            likeButton.setImage(Images.heart, for: .normal)
        } else {
            UserDefaultManager.shared.addLikeList(productId: productId)
            likeButton.setImage(Images.heartFill, for: .normal)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resultImageView.contentMode = .scaleAspectFill
        resultImageView.clipsToBounds = true
        resultImageView.layer.cornerRadius = 10
        
        likeButton.layer.cornerRadius = likeButton.layer.frame.width / 2
        likeButton.tintColor = .black
        likeButton.backgroundColor = .white
    }
}
