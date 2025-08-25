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
    
    var authCoord: AuthCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navContr = UINavigationController()
        self.addChild(navContr)
        self.view.addInscribed(navContr.view)
        navContr.didMove(toParent: self)
        
        let authCoord = AuthCoordinator(navigationController: navContr)
        authCoord.start()
        
        self.authCoord = authCoord
    }


}

protocol AnyViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(_: Input) -> Output
}




