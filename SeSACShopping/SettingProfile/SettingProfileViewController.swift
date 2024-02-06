//
//  SettingProfileViewController.swift
//  SeSACShopping
//
//  Created by Seryun Chun on 2024/01/19.
//

import UIKit

class SettingProfileViewController: UIViewController {
    
    // MARK: - UI Properties
    
    @IBOutlet var mainProfileImageView: UIImageView!
    @IBOutlet var profileImages: [UIImageView]!
    
    // MARK: - Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSettingProfileUI()
        setButtonTag()
    }
    
    // MARK: - IBAction Method
    
    @IBAction func profileImageSelected(_ sender: UITapGestureRecognizer) {
        let selectedImageTag = sender.view?.tag ?? 0
        let selectedImageName = "profile\(selectedImageTag + 1)"
        mainProfileImageView.image = UIImage(named: selectedImageName)
        UserDefaultManager.shared.setProfileImageName(value: selectedImageName)
        
        for image in profileImages {
            if image.tag == selectedImageTag {
                image.layer.borderWidth = 4
                image.layer.borderColor = Colors.pointGreen.cgColor
            } else {
                image.layer.borderColor = .none
            }
        }
    }
    
    func setButtonTag() {
        let imageViewNumber = 16
        for idx in 0..<imageViewNumber {
            profileImages[idx].tag = idx
        }
    }
}

// MARK: - UI Configuration Methods

extension SettingProfileViewController {
    func configureSettingProfileUI() {
        navigationItem.title = "프로필 설정"
        
        let imageName = UserDefaultManager.shared.getProfileImageName() ?? ""
        
        mainProfileImageView.image = UIImage(named: imageName)
        mainProfileImageView.layer.borderWidth = 4
        mainProfileImageView.layer.borderColor = Colors.pointGreen.cgColor
        mainProfileImageView.layer.cornerRadius = mainProfileImageView.bounds.width / 2
        mainProfileImageView.isUserInteractionEnabled = true
        
        let imageNumber = Images.profiles.count
        
        for idx in 0..<imageNumber {
            profileImages[idx].image = Images.profiles[idx]
            profileImages[idx].layer.cornerRadius = profileImages[idx].bounds.width / 2
            profileImages[idx].isUserInteractionEnabled = true
            
            if profileImages[idx].image == UIImage(named: imageName) {
                profileImages[idx].layer.borderWidth = 4
                profileImages[idx].layer.borderColor = Colors.pointGreen.cgColor
            } else {
                profileImages[idx].layer.borderColor = .none
            }
        }
    }
}


