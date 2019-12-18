//
//  SwipeRightDismissViewcontroller.swift
//  20191018_swiftCommonTool
//
//  Created by Yen on 2019/11/1.
//  Copyright © 2019 com.pacify.mplatform. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}
class SwipeRightDismissViewcontroller: UIViewController,UINavigationControllerDelegate {

    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let _ = self.panGestureRecognizer.view else{
            return nil
        }
        return SlideAnimatedTransitioning()
    }
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        navigationController.delegate = nil
        
        if panGestureRecognizer.state == .began {
            percentDrivenInteractiveTransition = UIPercentDrivenInteractiveTransition()
            percentDrivenInteractiveTransition.completionCurve = .easeOut
        } else {
            percentDrivenInteractiveTransition = UIPercentDrivenInteractiveTransition()
        }
        
        return percentDrivenInteractiveTransition
    }
    
    
}

extension SwipeRightDismissViewcontroller {
    
    private static var _panGestureRecognizer = [String:UIPanGestureRecognizer]()
    
    var panGestureRecognizer:UIPanGestureRecognizer {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return SwipeRightDismissViewcontroller._panGestureRecognizer[tmpAddress] ?? UIPanGestureRecognizer()
        }
        set(newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            SwipeRightDismissViewcontroller._panGestureRecognizer[tmpAddress] = newValue
        }
    }
    
    
    private static var _percentDrivenInteractiveTransition = [String:UIPercentDrivenInteractiveTransition]()
    
    var percentDrivenInteractiveTransition:UIPercentDrivenInteractiveTransition {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return SwipeRightDismissViewcontroller._percentDrivenInteractiveTransition[tmpAddress] ?? UIPercentDrivenInteractiveTransition()
        }
        set(newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            SwipeRightDismissViewcontroller._percentDrivenInteractiveTransition[tmpAddress] = newValue
        }
    }
    
    
    
    
    func addSwipeRightDismissGesture() {
        
        guard self.navigationController?.viewControllers.count ?? 0 > 1 else {
            return
        }
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SwipeRightDismissViewcontroller.handlePanGesture(_:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        
        let percent = max(panGesture.translation(in: view).x, 0) / view.frame.width
        
        switch panGesture.state {
            
        case .began:
            navigationController?.delegate = self
            _ = navigationController?.popViewController(animated: true)
            
        case .changed:
            percentDrivenInteractiveTransition.update(percent)
            
        case .ended:
            let velocity = panGesture.velocity(in: view).x
            
            // Continue if drag more than 50% of screen width or velocity is higher than 1000
            if percent > 0.5 || velocity > 1000 {
                percentDrivenInteractiveTransition.finish()
            } else {
                percentDrivenInteractiveTransition.cancel()
            }
            
        case .cancelled, .failed:
            percentDrivenInteractiveTransition.cancel()
            
        default:
            break
        }
    }
    
}
