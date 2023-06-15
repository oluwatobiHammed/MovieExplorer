//
//  UIViewControllerExtension.swift
//  MovieExplorer
//
//  Created by Oluwatobi Oladipupo on 09/06/2023.
//

import UIKit

extension UIViewController {
    
    
    var tabBarHeight: CGFloat {
        return  10 + (tabBarController?.tabBar.frame.size.height ?? 0)
    }
    
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
    
    @objc func hideSearchbar(isShown: Bool = true) {}
    
    @objc func adjustKeyboard(bottomConstraint: CGFloat) {}
    
    /**
    Gathers all the data defined in `Keyboard Notification User Info Keys` from
    a keyboard will/did show/hide `NSNotification` into an easier to use tuple.
    - parameter notification: A notification resulting from a keyboard appearance notification,
            e.g. `UIKeyboardWillShowNotification`
    - returns: A tuple of data about the keyboard appearance extracted from the notification user info.
    */
    private func keyboardInfoFromNotification(_ notification: Notification) -> (beginFrame: CGRect, endFrame: CGRect, animationCurve: UIView.AnimationOptions, animationDuration: Double) {
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
    
    
    @objc private func handleKeyboardHide(notification: Notification) {
        
        let keyboardData = keyboardInfoFromNotification(notification)
        
        adjustKeyboard(bottomConstraint: tabBarHeight)
        weak var weakSelf = self
        UIView.animate(withDuration: keyboardData.animationDuration,
                       delay: 0,
                       options: keyboardData.animationCurve,
                       animations: {
                        weakSelf?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func handleKeyboardShow(notification: Notification) {
        
        let keyboardData = keyboardInfoFromNotification(notification)
        adjustKeyboard(bottomConstraint: keyboardData.endFrame.height + 5)
        
        weak var weakSelf = self
        UIView.animate(withDuration: keyboardData.animationDuration,
                       delay: 0,
                       options: keyboardData.animationCurve,
                       animations: {
            weakSelf?.view.layoutIfNeeded()
        }, completion: nil)
     
    }
    
   func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}


extension UIViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if hideTabbar() { changeTabBar(hidden: scrollView.panGestureRecognizer.translation(in: scrollView).y < 0, animated: true) }
    }
    
    private func changeTabBar(hidden:Bool, animated: Bool) {
        
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
