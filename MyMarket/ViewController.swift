//
//  ViewController.swift
//  MyMarket
//
//  Created by Bohdan Huk on 16.08.2025.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let credentionalsCollectVM = CredentionalsCollectVM()
        let credentionalsCollectVC = CredentionalsCollectVC()
        credentionalsCollectVC.viewModel = credentionalsCollectVM
        
        let viewController = CompanyLogoContainerVC(
            contentVC: credentionalsCollectVC
        )
        viewController.updateContentInsents(.init(top: 20, left: 25, bottom: 100, right: 25))
        self.addChild(viewController)
        self.view.addInscribed(viewController.view)
        viewController.didMove(toParent: self)
        
        /*
        self.addChild(credentionalsCollectVC)
        let credentionalsView = credentionalsCollectVC.view ?? UIView()
        self.view.addSubview(credentionalsView)
        credentionalsView.translatesAutoresizingMaskIntoConstraints = false
        self.view.centerXAnchor.constraint(equalTo: credentionalsView.centerXAnchor).isActive = true
        self.view.centerYAnchor.constraint(equalTo: credentionalsView.centerYAnchor).isActive = true
        credentionalsCollectVC.didMove(toParent: self)*/
    }


}

protocol AnyViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(_: Input) -> Output
}




