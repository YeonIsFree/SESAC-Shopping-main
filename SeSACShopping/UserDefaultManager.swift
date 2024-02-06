//
//  UserDefaultManager.swift
//  SeSACShopping
//
//  Created by Seryun Chun on 2024/01/18.
//

import UIKit

class UserDefaultManager {
    
    private init() { }
    
    static let shared = UserDefaultManager()
    
    let ud = UserDefaults.standard
    
     // MARK: - Onboarding Status
    
    func getOnboardingStatus() -> Bool {
        return UserDefaultManager.shared.ud.bool(forKey: UserDefaultsKey.onboardingState.rawValue)
    }
    
    func setOnboardingStatus(value: Bool) {
        UserDefaultManager.shared.ud.set(value, forKey: UserDefaultsKey.onboardingState.rawValue)
    }
    
     // MARK: - User Name
    
    func getUserName() -> String? {
        return UserDefaultManager.shared.ud.string(forKey: UserDefaultsKey.userName.rawValue)
    }
    
    func setUserName(userName: String) {
        UserDefaultManager.shared.ud.set(userName, forKey: UserDefaultsKey.userName.rawValue)
    }
    
     // MARK: - Profile Image Name
    
    func getProfileImageName() -> String? {
        return UserDefaultManager.shared.ud.string(forKey: UserDefaultsKey.userProfileImage.rawValue)
    }
    
    func setProfileImageName(value: String) {
        UserDefaultManager.shared.ud.set(value, forKey: UserDefaultsKey.userProfileImage.rawValue)
    }
    
     // MARK: - Search List
    
    func getSearchList() -> [String] {
        return UserDefaults.standard.stringArray(forKey: UserDefaultsKey.searchList.rawValue) ?? []
    }
    
    func updateSearchList(value: [String]) {
        UserDefaultManager.shared.ud.set(value, forKey: UserDefaultsKey.searchList.rawValue)
    }
    
     // MARK: - LikeList
    
    func getLikeList() -> [String] {
        return UserDefaults.standard.stringArray(forKey: UserDefaultsKey.likeList.rawValue) ?? []
    }
    
    func addLikeList(productId: String) {
        var likeList = getLikeList()
        likeList.append(productId)
        UserDefaults.standard.setValue(likeList, forKey: UserDefaultsKey.likeList.rawValue)
    }
    
    func removeLike(productId: String) {
        var likeList = getLikeList()
        for index in 0..<likeList.count {
            if productId == likeList[index] {
                likeList.remove(at: index)
                break
            }
        }
        UserDefaults.standard.setValue(likeList, forKey: UserDefaultsKey.likeList.rawValue)
    }
    
     // MARK: - Sorting Status
    
    func getSortingStatus() -> String? {
        return UserDefaultManager.shared.ud.string(forKey: UserDefaultsKey.sortingStatus.rawValue)
    }
    
    func setSortingStatus(value: String) {
        UserDefaultManager.shared.ud.set(value, forKey: UserDefaultsKey.sortingStatus.rawValue)
    }
    
     // MARK: - Remove All UserDefaults Data
    
    static func removeAllData() {
        for key in UserDefaultsKey.allCases {
            shared.ud.removeObject(forKey: key.rawValue)
        }
    }
}
