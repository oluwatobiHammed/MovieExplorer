//
//  UIViewControllerExtension.swift
//  MovieExplorer
//
//  Created by Oluwatobi Oladipupo on 09/06/2023.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    class func displaySpinner(on appendView: UIView, sizeOf referView: UIView) -> UIView {
        let ai = UIActivityIndicatorView(style: .large)
        ai.startAnimating()
        ai.center = referView.center
        ai.backgroundColor = .white
        appendView.addSubview(ai)
        ai.isHidden = true
        return ai
    }

    class func removeSpinner(spinner: UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    
    /**
    Gathers all the data defined in `Keyboard Notification User Info Keys` from
    a keyboard will/did show/hide `NSNotification` into an easier to use tuple.
    - parameter notification: A notification resulting from a keyboard appearance notification,
            e.g. `UIKeyboardWillShowNotification`
    - returns: A tuple of data about the keyboard appearance extracted from the notification user info.
    */
    public func keyboardInfoFromNotification(_ notification: Notification) -> (beginFrame: CGRect, endFrame: CGRect, animationCurve: UIView.AnimationOptions, animationDuration: Double) {
        let userInfo = (notification as NSNotification).userInfo!
        let beginFrameValue = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let endFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber

        return (
            beginFrame:         beginFrameValue.cgRectValue,
            endFrame:           endFrameValue.cgRectValue,
            animationCurve:     UIView.AnimationOptions(rawValue: UInt(animationCurve.uintValue << 16)),
            animationDuration:  animationDuration.doubleValue)
    }
}

