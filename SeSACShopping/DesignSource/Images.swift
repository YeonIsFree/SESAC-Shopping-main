//
//  Images.swift
//  SeSACShopping
//
//  Created by Seryun Chun on 2024/01/18.
//

import UIKit

enum Images {
    // 새싹 로고 이미지
    static let logo: UIImage = UIImage(resource: .sesacShopping)
    
    // 온보딩 이미지
    static let onboarding: UIImage = UIImage(resource: .onboarding)
    
    // 카메라 버튼 이미지
    static let camera: UIImage = UIImage(resource: .camera)
    
    // 아이콘 이미지
    static let search: UIImage = UIImage(systemName: "magnifyingglass")!
    static let delete: UIImage = UIImage(systemName: "multiply")!
    static let heartFill: UIImage = UIImage(systemName: "heart.fill")!
    static let heart: UIImage = UIImage(systemName: "heart")!
    
    // empty Cell 이미지
    static let empty: UIImage = UIImage(resource: .empty)
    
    // 프로필 이미지
    static let profile1: UIImage = UIImage(resource: .profile1)
    static let profile2: UIImage = UIImage(resource: .profile2)
    static let profile3: UIImage = UIImage(resource: .profile3)
    static let profile4: UIImage = UIImage(resource: .profile4)
    static let profile5: UIImage = UIImage(resource: .profile5)
    static let profile6: UIImage = UIImage(resource: .profile6)
    static let profile7: UIImage = UIImage(resource: .profile7)
    static let profile8: UIImage = UIImage(resource: .profile8)
    static let profile9: UIImage = UIImage(resource: .profile9)
    static let profile10: UIImage = UIImage(resource: .profile10)
    static let profile11: UIImage = UIImage(resource: .profile11)
    static let profile12: UIImage = UIImage(resource: .profile12)
    static let profile13: UIImage = UIImage(resource: .profile13)
    static let profile14: UIImage = UIImage(resource: .profile14)
    
    // 프로필 이미지 배열
    static let profiles: [UIImage] = [profile1, profile2, profile3,profile4, profile5, profile6,profile7, profile8, profile9,profile10, profile11, profile12, profile13, profile14]
}
