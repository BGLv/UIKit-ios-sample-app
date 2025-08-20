//
//  UIViewController+Keyboard.swift
//  MyMarket
//
//  Created by Bohdan Huk on 20.08.2025.
//

import UIKit

extension UIViewController {
    func observeKeyboardWillAppear() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillAppear(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    func observeKeyboardDidAppear() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidAppear(_:)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
    }
    
    func observeKeyboardWillHide() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func observeKeyboardDidHide() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidHide(_:)),
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillAppear(_ notification: Notification) {
        print("Keyboard will appear")
    }
    
    @objc func keyboardDidAppear(_ notification: Notification) {
        print("Keyboard did appear")
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        print("Keyboard will hide")
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        print("Keyboard did hide")
    }
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
