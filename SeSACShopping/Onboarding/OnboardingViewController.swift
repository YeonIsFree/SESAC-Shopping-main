//
//  OnboardingViewController.swift
//  SeSACShopping
//
//  Created by Seryun Chun on 2024/01/18.
//

import UIKit

class OnboardingViewController: UIViewController {
    
     // MARK: - UI Properties
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var onboardingImageView: UIImageView!
    @IBOutlet var startButton: UIButton!
    
    // MARK: - Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureOnboardingUI()
        
        navigationItem.backButtonTitle = ""
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
}

 // MARK: - UI Configuration Method

extension OnboardingViewController {
     func configureOnboardingUI() {
        logoImageView.image = Images.logo
        logoImageView.contentMode = .scaleAspectFit
        
        onboardingImageView.image = Images.onboarding
        onboardingImageView.contentMode = .scaleAspectFit
        
        startButton.setTitle("시작하기", for: .normal)
        startButton.setTitleColor(Colors.textWhite, for: .normal)
        startButton.titleLabel?.font = Fonts.b17
        startButton.backgroundColor = Colors.pointGreen
        startButton.layer.cornerRadius = 10
    }
}

 // MARK: - Button Configuration Methods

extension OnboardingViewController {
    @objc func startButtonTapped() {
        let sb = UIStoryboard(name: StoryBoardNames.Profile.rawValue, bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: ProfileViewController.identifier) as? ProfileViewController else {
            return }
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(vc, animated: true)
    }
}
