//
//  NavigationManager.swift
//  PlayerPoll
//
//  Created by mac on 13/10/21.
//

import UIKit
import Hero

class MyController: UIViewController,UINavigationControllerDelegate {
    //MARK:- IBOutlets
    fileprivate let heroTransition = HeroTransition()
    
    //MARK:- Variable Declarations
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        self.navigationController?.heroNavigationAnimationType = .selectBy(presenting: .zoomSlide(direction: .left), dismissing:.zoomSlide(direction: .right))
        // Do any additional setup after loading the view.
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
           -> UIViewControllerInteractiveTransitioning? {
           return heroTransition.navigationController(navigationController, interactionControllerFor: animationController)
       }

       func navigationController(_ navigationController: UINavigationController,
                                 animationControllerFor operation: UINavigationController.Operation,
                                 from fromVC: UIViewController,
                                 to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
           return heroTransition.navigationController(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
       }
}
