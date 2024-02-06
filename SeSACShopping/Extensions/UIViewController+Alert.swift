//
//  UIViewController+Alert.swift
//  SeSACShopping
//
//  Created by Seryun Chun on 2024/01/22.
//

import UIKit

extension UIViewController {
    func alert() {
        let alert = UIAlertController(title: "처음부터 시작하기", message: "데이터를 모두 초기화 하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            UserDefaultManager.removeAllData()
            
            let sb = UIStoryboard(name: StoryBoardNames.Onboarding.rawValue, bundle: nil)
            guard let vc = sb.instantiateViewController(withIdentifier: OnboardingViewController.identifier) as? OnboardingViewController else { return }
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
