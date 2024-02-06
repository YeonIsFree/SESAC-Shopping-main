//
//  ViewController.swift
//  SeSACShopping
//
//  Created by Seryun Chun on 2024/01/18.
//

import UIKit

class HomeViewController: UIViewController {
    
    var recentSearchList = UserDefaultManager.shared.getSearchList() {
        didSet {
            UserDefaultManager.shared.updateSearchList(value: recentSearchList)
            tableViewHeader.isHidden = recentSearchList.isEmpty ? true : false
            mainTableView.reloadData()
        }
    }
    
    // MARK: - UI Properties
    
    @IBOutlet var mainTableView: UITableView!
    @IBOutlet var mainSearchbar: UISearchBar!
    @IBOutlet var tableViewHeader: UIView!
    @IBOutlet var tableViewHeaderLabel: UILabel!
    @IBOutlet var tableViewHeaderButton: UIButton!
    
    // MARK: - Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSearchBar()
        configureTableViewHeaderUI()
        showTableViewHeader()
        configureRemoveAllButton()
        configureNavigationTitle()
    }
}

// MARK: - Navitaion Title Configuration Method

extension HomeViewController {
    func configureNavigationTitle() {
        navigationController?.navigationBar.tintColor = .white
        if let userName = UserDefaultManager.shared.getUserName() {
            navigationItem.title = "\(userName)님의 새싹쇼핑"
        } else {
            navigationItem.title = "새싹쇼핑"
        }
    }
}

// MARK: - UITableView Delegate

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func cellBounceFixed() {
        mainTableView.separatorStyle = .none
        mainTableView.allowsSelection = false
        mainTableView.bounces = false
    }
    
    func configureTableView() {
        if recentSearchList.isEmpty {
            cellBounceFixed()
        } else {
            mainTableView.separatorStyle = .none
            mainTableView.allowsSelection = true
            mainTableView.bounces = true
        }
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        let emptyXib = UINib(nibName: EmptyTableViewCell.identifier, bundle: nil)
        mainTableView.register(emptyXib, forCellReuseIdentifier: EmptyTableViewCell.identifier)
        
        let mainXib = UINib(nibName: HomeTableViewCell.identifier, bundle: nil)
        mainTableView.register(mainXib, forCellReuseIdentifier: HomeTableViewCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recentSearchList.isEmpty {
            return 1
        } else {
            return recentSearchList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if recentSearchList.isEmpty {
            guard let cell = mainTableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.identifier) as? EmptyTableViewCell else { return UITableViewCell() }
            cellBounceFixed()
            cell.configureEmptyCell()
            return cell
        } else {
            guard let cell = mainTableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier) as? HomeTableViewCell else { return UITableViewCell() }
            cell.configureMainCell(recentSearchList[indexPath.row])
            cell.deleteButton.tag = indexPath.row
            cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
            return cell
        }
    }
    
    @objc func deleteButtonTapped(sender: UIButton) {
        let indexPathRow = sender.tag
        recentSearchList.remove(at: indexPathRow)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if recentSearchList.isEmpty {
            return 500
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: StoryBoardNames.SearchResult.rawValue, bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: SearchResultViewController.identifier) as? SearchResultViewController else { return }
        vc.targetKeyword = recentSearchList[indexPath.row]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UISearchBar Delegate

extension HomeViewController: UISearchBarDelegate {
    func configureSearchBar() {
        mainSearchbar.delegate = self
        mainSearchbar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        mainSearchbar.barTintColor = .clear
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        recentSearchList.insert(searchBar.text!, at: 0)
        
        let sb = UIStoryboard(name: StoryBoardNames.SearchResult.rawValue, bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: SearchResultViewController.identifier) as? SearchResultViewController else { return }
        vc.targetKeyword = searchBar.text!
        searchBar.text = ""
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TableView Header Configuration Methods

extension HomeViewController {
    func showTableViewHeader() {
        tableViewHeader.isHidden = recentSearchList.isEmpty ? true : false
    }
    
    func configureTableViewHeaderUI() {
        tableViewHeaderLabel.text = "최근 검색"
        tableViewHeaderLabel.font = Fonts.b16
        
        tableViewHeaderButton.setTitle("모두 지우기", for: .normal)
        tableViewHeaderButton.titleLabel?.font = Fonts.b14
        tableViewHeaderButton.setTitleColor(Colors.pointGreen, for: .normal)
    }
    
    func configureRemoveAllButton() {
        tableViewHeaderButton.addTarget(self, action: #selector(tableViewHeaderButtonTapped), for: .touchUpInside)
    }
    
    @objc func tableViewHeaderButtonTapped() {
        recentSearchList.removeAll()
    }
}
