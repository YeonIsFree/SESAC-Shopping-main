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
        do {
            try validateNickname(sender.text!)
            validatationLabel.text = "사용할 수 있는 닉네임이에요"
            doneButton.isHidden = false
        } catch {
            doneButton.isHidden = true
            
            switch error {
            case nicknameValidationError.invalidLength:
                validatationLabel.text = nicknameValidationError.invalidLength.alert
            case nicknameValidationError.containSpecialChar:
                validatationLabel.text = nicknameValidationError.containSpecialChar.alert
            case nicknameValidationError.containNumber:
                validatationLabel.text = nicknameValidationError.containNumber.alert
            default:
                validatationLabel.text = "사용할 수 없는 닉네임이에요"
            }
        }
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

 // MARK: - nickname Validation Methods

extension ProfileViewController {
    // 에러 종류들을 미리 정의
    enum nicknameValidationError: Error {
        case invalidLength
        case containSpecialChar
        case containNumber
        
        var alert: String {
            switch self {
            case .invalidLength:
                return "2글자 이상 10글자 미만으로 설정해주세요"
            case .containSpecialChar:
                return "닉네임에 @, #, $, %는 포함할 수 없어요"
            case .containNumber:
                return "닉네임에 숫자는 포함할 수 없어요"
            }
        }
    }
    
    // 에러가 발생할 수 있는 함수에 대한 정의
    func validateNickname(_ text: String) throws {
        if isInvalidLength(text) {
            throw nicknameValidationError.invalidLength
        } else if isContainSpecialChar(text) {
            throw nicknameValidationError.containSpecialChar
        } else if isContainNumber(text) {
            throw nicknameValidationError.containNumber
        } else {
            return
        }
    }
    
    // 유효하지 않은 길이의 문자열이면 true를 반환
    func isInvalidLength(_ text: String) -> Bool {
        return (text.count >= 2 && text.count < 10) ? false : true
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
