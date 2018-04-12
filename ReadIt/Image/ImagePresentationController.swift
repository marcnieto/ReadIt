//
//  ImagePresentationController.swift
//  ReadIt
//
//  Created by Marc Nieto on 4/12/18.
//  Copyright © 2018 Marc Nieto. All rights reserved.
//

import UIKit

class ImagePresentationController: UIPresentationController {

    // MARK: - Accessing

    let source: ImageViewController
    fileprivate var dimmingView: UIView!

    // MARK: - Initialize

    init(presentedViewController: ImageViewController, presenting presentingViewController: UIViewController?, source: UIViewController) {
        self.source = presentedViewController
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.setupDimmingView()
    }

    private func setupDimmingView() {
        self.dimmingView = UIView()
//        self.dimmingView.translatesAutoresizingMaskIntoConstraints = false
        self.dimmingView.backgroundColor = .clear
        self.dimmingView.alpha = 0.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ImagePresentationController.cancel(_:)))
        self.dimmingView.addGestureRecognizer(tapGesture)
    }

    // MARK: - Actions

    @objc func cancel(_ sender: Any?) {
        self.source.dismiss(animated: true, completion: nil)
    }

    // MARK: - UIPresentationController

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        let containerView = self.containerView!
        containerView.insertSubview(self.dimmingView, belowSubview: self.presentedViewController.view)

        UIView.animate(withDuration: 0.4) {
            self.dimmingView.alpha = 1.0
        }
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        UIView.animate(withDuration: 0.4) {
            self.dimmingView.alpha = 0.0
        }
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        let containerView = self.containerView!
        let bounds = containerView.bounds
        self.dimmingView.frame = bounds
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        let containerBounds = self.containerView!.bounds
        let width = self.source.view.bounds.width
        let height = self.source.view.bounds.height
        let finalX: CGFloat = (containerBounds.width - width) / 2.0
        let finalY: CGFloat = (containerBounds.height - height) / 2.0

        return CGRect(x: finalX, y: finalY, width: width, height: height)
    }

    override var presentedView: UIView? {
        let presentedView = super.presentedView

//        UIView.performWithoutAnimation {
//            let rect = self.frameOfPresentedViewInContainerView
//            presentedView?.bounds = rect
//            presentedView?.center = CGPoint(x: rect.midX, y: rect.minY)
//        }

        return presentedView
    }
}

class ImageAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - Accessing

    let isPresenting: Bool
    let source: ImageViewController

    // MARK: - Initialize

    init(for presenting: Bool, source: ImageViewController) {
        self.isPresenting = presenting
        self.source = source
        super.init()
    }

    // MARK: - UIViewControllerAnimatedTransitioning

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let viewController: UIViewController
        let view: UIView

        if self.isPresenting {
            viewController = transitionContext.viewController(forKey: .to)!
            view = transitionContext.view(forKey: .to)!
        } else {
            viewController = transitionContext.viewController(forKey: .from)!
            view = transitionContext.view(forKey: .from)!
        }

        let containerView = transitionContext.containerView
        let rect = transitionContext.finalFrame(for: viewController)
        view.frame = rect

        let initialCenter = self.source.initialLocation

        if self.isPresenting {
            view.transform = CGAffineTransform(scaleX: 0.33, y: 0.33)
            view.center = initialCenter
            view.alpha = 0.0
            containerView.addSubview(view)
            UIView.animate(withDuration: 0.4) {
                view.center = CGPoint(x: rect.midX, y: rect.midY)
                view.transform = .identity
                view.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                view.center = initialCenter
                view.transform = CGAffineTransform(scaleX: 0.33, y: 0.33)
                view.alpha = 0.0
            }
        }
    }
}
