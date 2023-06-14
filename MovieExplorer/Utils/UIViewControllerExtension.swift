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
    
    @objc func hideTabbar(isShown: Bool = true) -> Bool {
       return isShown
    }
    
    @objc func hideSearchbar(isShown: Bool = true) {
    
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


extension UIViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if hideTabbar() { changeTabBar(hidden: scrollView.panGestureRecognizer.translation(in: scrollView).y < 0, animated: true) }
    }
    
    func changeTabBar(hidden:Bool, animated: Bool) {
        
        let tabBar = self.tabBarController?.tabBar
        let offset = (hidden ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.height - (tabBar?.frame.size.height)! )
        if offset == tabBar?.frame.origin.y {return}
        let duration:TimeInterval = (animated ? 0.5 : 0.0)
        UIView.animate(withDuration: duration,
                       animations: { [self] in
            tabBar!.frame.origin.y = offset
            hideSearchbar(isShown: hidden)
            view.layoutIfNeeded()
        }, completion:nil)
    }
}
