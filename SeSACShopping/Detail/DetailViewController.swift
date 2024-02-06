//
//  DetailViewController.swift
//  SeSACShopping
//
//  Created by Seryun Chun on 2024/01/21.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var productId: String = ""
    var productName: String = ""
    
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebKitView()
        configureDetailViewUI()
    }
    
    func configureWebKitView() {
        let link: String = "https://msearch.shopping.naver.com/product/\(productId)"
        if let url = URL(string: link) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func configureDetailViewUI() {
        navigationItem.title = productName
        
        let likeList = UserDefaultManager.shared.getLikeList()
        let isLiked = likeList.contains(productId)
        let barbuttonImage = isLiked ? Images.heartFill : Images.heart
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: barbuttonImage, style: .plain, target: self, action: #selector(likeBarButtonTapped))
    }
    
    @objc func likeBarButtonTapped() {
        let likeList = UserDefaultManager.shared.getLikeList()
        let isLiked = likeList.contains(productId)
        if isLiked {
            UserDefaultManager.shared.removeLike(productId: productId)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.heart, style: .plain, target: self, action: #selector(likeBarButtonTapped))
        } else {
            UserDefaultManager.shared.addLikeList(productId: productId)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.heartFill, style: .plain, target: self, action: #selector(likeBarButtonTapped))
        }
    }
}
