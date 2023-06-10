//
//  AlertManager.swift
//  MovieExplorer
//
//  Created by Oluwatobi Oladipupo on 10/06/2023.
//

import UIKit

class AlertManager {
    static let sharedAlertManager = AlertManager()

    func showAlertWithTitle(title: String, message: String, controller: UIViewController, handler: @escaping ((UIAlertAction) -> Void) = { _ in }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        controller.present(alert, animated: true, completion: nil)
    }

 
}
