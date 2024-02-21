//
//  UIViewController+Ext.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 10.02.2024.
//

import Foundation
import UIKit
import SafariServices

extension UIViewController {
    func presentAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async{
            let alertVC = AlertVC(message: message, title: title, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    

    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .red
        present(safariVC, animated: true)
    }
}
