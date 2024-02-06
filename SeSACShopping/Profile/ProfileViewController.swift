//
//  ProfileViewController.swift
//  SeSACShopping
//
//  Created by Seryun Chun on 2024/01/18.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var isValidUserName: Bool = false
    var userName: String = "" {
        didSet {
            UserDefaultManager.shared.setUserName(userName: userName)
        }
    }
    
     // MARK: - UI Properties
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var cameraIconImageView: UIImageView!
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var validatationLabel: UILabel!
    @IBOutlet var doneButton: UIButton!

     // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProfileUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let imageName = UserDefaultManager.shared.getProfileImageName() {
            profileImageView.image = UIImage(named: imageName)
        } else {
            profileImageView.image = Images.profiles.randomElement()
        }
    }
    
     // MARK: - IBAction Methods
    
    @IBAction func textFieldValueChanged(_ sender: UITextField) {
        nicknameValidate(sender.text!)
        doneButton.isHidden = isValidUserName ? false : true
    }
    
    @IBAction func profileImageTapped(_ sender: UITapGestureRecognizer) {
        let sb = UIStoryboard(name: StoryBoardNames.SettingProfile.rawValue, bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: SettingProfileViewController.identifier) as? SettingProfileViewController else { return }
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        if isValidUserName {
            userName = nicknameTextField.text!
            
            UserDefaultManager.shared.setOnboardingStatus(value: true)
            
            let sb = UIStoryboard(name: StoryBoardNames.Main.rawValue, bundle: nil)
            guard let vc = sb.instantiateViewController(withIdentifier: StoryBoardNames.MainTabBar.rawValue) as? UITabBarController else { return }
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
}

 // MARK: - nickname Validation

extension ProfileViewController {
    func nicknameValidate(_ text: String) {
        if !isValidLength(text) {
            validatationLabel.text = "2글자 이상 10글자 미만으로 설정해주세요"
            isValidUserName = false
            return
        }
        
        if isContainSpecialChar(text) {
            validatationLabel.text = "닉네임에 @, #, $, %는 포함할 수 없어요"
            isValidUserName = false
            return
        }
        
        if isContainNumber(text) {
            validatationLabel.text = "닉네임에 숫자는 포함할 수 없어요"
            isValidUserName = false
            return
        }
        
        validatationLabel.text = "사용할 수 있는 닉네임이에요"
        isValidUserName = true
    }

    func isValidLength(_ text: String) -> Bool {
        return (text.count >= 2 && text.count < 10) ? true : false
    }
    
    // 특수문자를 포함하면 true를 반환
    func isContainSpecialChar(_ text: String) -> Bool {
        let regex = "^.*[@#$%].*$"
        return text.range(of: regex, options: .regularExpression) != nil
    }
    
    // 숫자를 포함하면 true를 반환
    func isContainNumber(_ text: String) -> Bool {
        let regex = "^.*[0-9].*$"
        return text.range(of: regex, options: .regularExpression) != nil
    }
}

 // MARK: - UI Configuration Method

extension ProfileViewController {
    private func configureProfileUI() {
        navigationItem.title = "프로필 설정"
        navigationController?.navigationBar.tintColor = .white
        
        if let imageName = UserDefaultManager.shared.getProfileImageName() {
            profileImageView.image = UIImage(named: imageName)
        } else {
            let randomImage = "profile\(Int.random(in: 1...14))"
            profileImageView.image = UIImage(named: randomImage)
            UserDefaultManager.shared.setProfileImageName(value: randomImage)
        }
        
        profileImageView.layer.borderWidth = 4
        profileImageView.layer.borderColor = Colors.pointGreen.cgColor
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        profileImageView.isUserInteractionEnabled = true
        
        cameraIconImageView.image = Images.camera
        
        if let nickname = UserDefaultManager.shared.getUserName() {
            nicknameTextField.text = nickname
        }
        nicknameTextField.backgroundColor = Colors.backgroundBlack
        nicknameTextField.placeholder = "닉네임을 입력해주세요 :D"
        nicknameTextField.borderStyle = .none
        
        validatationLabel.text = ""
        validatationLabel.textColor = Colors.pointGreen
        validatationLabel.font = Fonts.m13
        
        doneButton.setTitle("완료", for: .normal)
        doneButton.setTitleColor(Colors.textWhite, for: .normal)
        doneButton.titleLabel?.font = Fonts.b17
        doneButton.backgroundColor = Colors.pointGreen
        doneButton.layer.cornerRadius = 10
    }
}
