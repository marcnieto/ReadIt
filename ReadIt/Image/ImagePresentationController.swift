//
//  ImagePresentationController.swift
//  ReadIt
//
//  Created by Marc Nieto on 4/15/18.
//  Copyright © 2018 Marc Nieto. All rights reserved.
//

import UIKit

class ImagePresentationController: UIPresentationController {
    
}

class ImageAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

    }
}
