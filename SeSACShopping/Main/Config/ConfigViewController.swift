//
//  ConfigViewController.swift
//  SeSACShopping
//
//  Created by Seryun Chun on 2024/01/21.
//

import UIKit

enum ConfigList: String, CaseIterable {
    case notice = "공지사항"
    case qna = "자주 묻는 질문"
    case contact = "1:1 문의"
    case alert = "알림 설정"
    case reset = "처음부터 시작하기"
}

class ConfigViewController: UIViewController {
    
    let configList = ConfigList.allCases
    
    // MARK: - UI Properties
    
    @IBOutlet var profileView: UIView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var likeSubLabel: UILabel!
    @IBOutlet var configTableView: UITableView!
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureConfigViewUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let likeCount = UserDefaultManager.shared.getLikeList().count
        likeLabel.text = "\(likeCount)개의 상품"
    }
    
    @IBAction func profileViewTapped(_ sender: UITapGestureRecognizer) {
        let sb = UIStoryboard(name: StoryBoardNames.Profile.rawValue, bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: ProfileViewController.identifier) as? ProfileViewController else { return }
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableView Delegate

extension ConfigViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        configList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = configTableView.dequeueReusableCell(withIdentifier: ConfigTableViewCell.identifier, for: indexPath) as? ConfigTableViewCell else { return UITableViewCell()}
        cell.configLabel.text = configList[indexPath.row].rawValue
        cell.configLabel.font = Fonts.m14
        cell.backgroundColor = .clear
        cell.isUserInteractionEnabled = (indexPath.row == 4) ? true : false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 { alert() }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func configureTableView() {
        configTableView.delegate = self
        configTableView.dataSource = self
        
        let configXib = UINib(nibName: ConfigTableViewCell.identifier, bundle: nil)
        configTableView.register(configXib, forCellReuseIdentifier: ConfigTableViewCell.identifier)
        
        configTableView.layer.cornerRadius = 10
        configTableView.backgroundColor = Colors.backgroundBlack
        configTableView.alwaysBounceVertical = false
    }
}
// MARK: - UI Configuration Method

extension ConfigViewController {
    func configureConfigViewUI() {
        profileView.backgroundColor = Colors.backgroundBlack
        profileView.layer.cornerRadius = 10
        profileView.isUserInteractionEnabled = true
        
        if let imageName = UserDefaultManager.shared.getProfileImageName() {
            profileImageView.image = UIImage(named: imageName)
            profileImageView.contentMode = .scaleAspectFill
        }
        profileImageView.layer.borderWidth = 4
        profileImageView.layer.borderColor = Colors.pointGreen.cgColor
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        
        if let userName = UserDefaultManager.shared.getUserName() {
            userNameLabel.text = userName
        }
        userNameLabel.font = Fonts.b20
        
        likeLabel.font = Fonts.b17
        likeLabel.textColor = Colors.pointGreen
        
        likeSubLabel.text = "을 좋아하고 있어요!"
        likeSubLabel.font = Fonts.b17
    }
}



