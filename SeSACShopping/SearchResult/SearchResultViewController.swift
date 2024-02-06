//
//  SearchResultViewController.swift
//  SeSACShopping
//
//  Created by Seryun Chun on 2024/01/21.
//

import UIKit
import Alamofire

enum SortingButton: String, CaseIterable {
    case relevantSortButton = "정확도순"
    case dateSortButton = "날짜순"
    case descPriceSortButton = "가격높은순"
    case ascePriceSortButton = "가격낮은순"
    
    var code: String {
        switch self {
        case .relevantSortButton:
            return "sim"
        case .dateSortButton:
            return "date"
        case .descPriceSortButton:
            return "dsc"
        case .ascePriceSortButton:
            return "asc"
        }
    }
}

class SearchResultViewController: UIViewController {
    
    var targetKeyword: String = ""
    var start = 1
    var sortingCode = "" {
        didSet {
            UserDefaultManager.shared.setSortingStatus(value: sortingCode)
            callRequest(searchKeyword: targetKeyword, sortingStatus: sortingCode)
            resultCollectionView.reloadData()
        }
    }
    var resultTotal: Int = 0
    var resultList: [Item] = [] {
        didSet {
            resultCollectionView.reloadData()
        }
    }
    
    // MARK: - UI Properties
    
    @IBOutlet var resultCollectionView: UICollectionView!
    @IBOutlet var resultHeaderLabel: UILabel!
    @IBOutlet var relevantSortButton: UIButton!
    @IBOutlet var dateSortButton: UIButton!
    @IBOutlet var descPriceSortButton: UIButton!
    @IBOutlet var ascePriceSortButton: UIButton!
    @IBOutlet var sortingButtons: [UIButton]!
    
    // MARK: - Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callRequest(searchKeyword: targetKeyword, sortingStatus: SortingButton.relevantSortButton.code)
        configureCollectionView()
        configureFlowLayout()
        configureSearchResultUI()
        
        // 초기 설정
        sortingCode = SortingButton.relevantSortButton.code
        relevantSortButton.tintColor = .black
        relevantSortButton.backgroundColor = .white
        
        // Button Action
        relevantSortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        dateSortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        descPriceSortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        ascePriceSortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resultCollectionView.reloadData()
    }
}

// MARK: - Button Action Method

extension SearchResultViewController {
    @objc func sortButtonTapped(sender: UIButton) {
        let tappedButton = sender.titleLabel?.text ?? ""
        sortingCode = SortingButton(rawValue: tappedButton)?.code ?? "sim"
        buttonSelectUI()
    }
    
    func buttonSelectUI() { // 선택된 버튼을 하얗게 칠해주는 함수
        let target = UserDefaultManager.shared.getSortingStatus() ?? ""
        for button in sortingButtons {
            let buttonTitle = button.titleLabel?.text ?? ""
            let code = SortingButton(rawValue: buttonTitle)?.code ?? ""
            if code == target {
                button.tintColor = .black
                button.backgroundColor = .white
            } else {
                button.tintColor = .white
                button.backgroundColor = .black
            }
        }
    }
}

// MARK: - UICollectionView Delegate

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func callRequest(searchKeyword: String, sortingStatus: String) {
        let query = searchKeyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url: String = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=30&start=\(start)&sort=\(sortingStatus)"
        
        let header: HTTPHeaders = [
            APIKey.NaverID: APIKey.clientID,
            APIKey.NaverSecret: APIKey.clientSecret
        ]
        
        AF
            .request(url, method: .get, headers: header)
            .responseDecodable(of: Result.self) { response in
                switch response.result {
                case .success(let success):
                    let totalNumber = NumberFormatter.convertNumber(String(success.total))
                    self.resultHeaderLabel.text = "\(totalNumber) 개의 검색 결과"
                    
                    if self.start == 1 {
                        self.resultList = success.items
                    } else {
                        self.resultList.append(contentsOf: success.items)
                    }
                    
                case .failure(let failure):
                    print(failure)
                }
            }
    }
    
    func configureCollectionView() {
        resultCollectionView.prefetchDataSource = self
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
        
        let resultXib = UINib(nibName: SearchResultCollectionViewCell.identifier, bundle: nil)
        resultCollectionView.register(resultXib, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
    }
    
    func configureFlowLayout() {
        let layout = UICollectionViewFlowLayout()
        let deviceWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 10
        let cellWidth = (deviceWidth - spacing * 3 ) / 2
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * 1.5)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical
        resultCollectionView.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = resultCollectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        
        // likeList 를 productId로 관리하기 위해 각 좋아요 버튼에 tag 부여
        let productId = resultList[indexPath.item].productId
        cell.likeButton.tag = Int(productId) ?? 0
        
        cell.configureSearchResultCell(itemList: resultList, index: indexPath.item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: StoryBoardNames.Detail.rawValue, bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: DetailViewController.identifier) as? DetailViewController else { return }
        vc.productId = resultList[indexPath.item].productId
        vc.productName = resultList[indexPath.item].title
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for item in indexPaths {
            if resultList.count == resultTotal {
                return
            }
            if resultList.count - 4 == item.row {
                start += 30
                callRequest(searchKeyword: targetKeyword, sortingStatus: sortingCode)
            }
        }
    }
}

// MARK: - UI Configuration Methods

extension SearchResultViewController {
    func configureSearchResultUI() {
        navigationItem.title = targetKeyword
        
        resultHeaderLabel.textColor = Colors.pointGreen
        resultHeaderLabel.font = Fonts.b14
        
        configureSortButtonUI(relevantSortButton, SortingButton.relevantSortButton.rawValue)
        configureSortButtonUI(dateSortButton, SortingButton.dateSortButton.rawValue)
        configureSortButtonUI(descPriceSortButton, SortingButton.descPriceSortButton.rawValue)
        configureSortButtonUI(ascePriceSortButton, SortingButton.ascePriceSortButton.rawValue)
    }
    
    func configureSortButtonUI(_ button: UIButton, _ title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = Fonts.r14
        button.contentEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        button.tintColor = .white
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
    }
}
