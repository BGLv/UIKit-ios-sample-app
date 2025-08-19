//
//  UIView+Extension.swift
//  MyMarket
//
//  Created by Bohdan Huk on 18.08.2025.
//

import UIKit

extension UIView {
    func addInscribed(_ subview: UIView, insets: UIEdgeInsets = .zero) {
        self.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.leftAnchor.constraint(
            equalTo: subview.leftAnchor,
            constant: -insets.left
        ).isActive = true
        self.trailingAnchor.constraint(
            equalTo: subview.trailingAnchor,
            constant: insets.right
        ).isActive = true
        self.bottomAnchor.constraint(
            equalTo: subview.bottomAnchor,
            constant: insets.bottom
        ).isActive = true
        self.topAnchor.constraint(
            equalTo: subview.topAnchor,
            constant: -insets.top
        ).isActive = true
    }
}
