//
//  CompanyLogoContainerVC.swift
//  MyMarket
//
//  Created by Bohdan Huk on 20.08.2025.
//
import UIKit

class CompanyLogoContainerVC: UIViewController {
    
    private lazy var companyLogoView = {
        let label = UILabel()
        label.text = "MyMarket"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let result = CAGradientLayer()
        result.frame = self.view.bounds
        result.colors = [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
        return result
    }()
    
    private lazy var bottomSheetView = {
        let result = UIView()
        result.backgroundColor = UIColor(red: 73/255, green: 75/255, blue: 80/255, alpha: 1.0)
        result.layer.cornerRadius = 20
        result.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return result
    }()
    
    private lazy var scrollableContentView = UIView()
    
    private lazy var scrollView = {
        let result = UIScrollView()
        result.addInscribed(self.scrollableContentView)
        let heightConstr = self.scrollableContentView.heightAnchor.constraint(equalTo: result.heightAnchor)
        heightConstr.priority = .defaultLow
        heightConstr.isActive = true
        
        let widthConstr = self.scrollableContentView.widthAnchor.constraint(equalTo: result.widthAnchor)
        widthConstr.priority = .defaultLow
        widthConstr.isActive = true
        return result
    }()
    
    private var contentVC = UIViewController()
    private var contentInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
    private var contentTopConstr = NSLayoutConstraint()
    private var contentBottomConstr = NSLayoutConstraint()
    private var contentLeadingConstr = NSLayoutConstraint()
    private var contentTrailingConstr = NSLayoutConstraint()
    
    private var bottomSheetTopConstr = NSLayoutConstraint()
    
    convenience init(contentVC: UIViewController) {
        self.init()
        self.contentVC = contentVC
    }
    
    func updateContentInsents(_ insets: UIEdgeInsets) {
        self.contentInsets = insets
        self.contentTopConstr.constant = insets.top
        self.contentBottomConstr.constant = -insets.bottom
        self.contentLeadingConstr.constant = insets.left
        self.contentTrailingConstr.constant = -insets.right
        self.view.setNeedsUpdateConstraints()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.observeKeyboardWillAppear()
        self.observeKeyboardWillHide()
        self.dismissKeyboardOnTap()
        
        self.view.addSubview(self.companyLogoView)
        self.setupConstrainsForCompanyLogo()
        
        self.view.addInscribed(self.scrollView)
        self.view.layer.insertSublayer(self.gradientLayer, at: 0)
        
        self.scrollableContentView.addSubview(self.bottomSheetView)
        self.setupConstrainsForBottomSheet()
        
        self.addChild(self.contentVC)
        self.bottomSheetView.addSubview(self.contentVC.view)
        self.setupConstrainsForContentView()
        self.updateContentInsents(self.contentInsets)
        self.contentVC.didMove(toParent: self)
    }
    
    private func setupConstrainsForCompanyLogo() {
        self.companyLogoView.translatesAutoresizingMaskIntoConstraints = false
        self.companyLogoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        self.companyLogoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        self.companyLogoView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
        self.companyLogoView.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.2).isActive = true
    }
    
    private func setupConstrainsForBottomSheet() {
        self.bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        self.bottomSheetView.bottomAnchor.constraint(equalTo: self.scrollableContentView.bottomAnchor).isActive = true
        self.bottomSheetView.leadingAnchor.constraint(equalTo: self.scrollableContentView.leadingAnchor).isActive = true
        self.bottomSheetView.trailingAnchor.constraint(equalTo: self.scrollableContentView.trailingAnchor).isActive = true
        self.bottomSheetTopConstr = self.bottomSheetView.topAnchor.constraint(
            equalTo: self.scrollableContentView.topAnchor,
            constant: self.view.bounds.height * 0.2
        )
        self.bottomSheetTopConstr.isActive = true
        self.bottomSheetView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
    
    private func setupConstrainsForContentView() {
        self.contentVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.contentTopConstr = self.contentVC.view.topAnchor.constraint(equalTo: self.bottomSheetView.safeAreaLayoutGuide.topAnchor)
        self.contentBottomConstr = self.contentVC.view.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomSheetView.bottomAnchor)
        self.contentLeadingConstr = self.contentVC.view.leadingAnchor.constraint(equalTo: self.bottomSheetView.leadingAnchor)
        self.contentTrailingConstr = self.contentVC.view.trailingAnchor.constraint(equalTo: self.bottomSheetView.trailingAnchor)
        
        [self.contentTopConstr, self.contentBottomConstr, self.contentLeadingConstr, self.contentTrailingConstr].forEach {
            $0.isActive = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientLayer.frame = self.view.bounds
    }
    
    @objc override func keyboardWillAppear(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        UIView.animate(withDuration: animationDuration) {
            self.bottomSheetTopConstr.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc override func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        UIView.animate(withDuration: animationDuration) {
            self.bottomSheetTopConstr.constant = self.view.bounds.height * 0.2
            self.view.layoutIfNeeded()
        }
    }
}
