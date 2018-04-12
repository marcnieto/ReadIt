//
//  ImageViewController.swift
//  ReadIt
//
//  Created by Marc Nieto on 4/12/18.
//  Copyright © 2018 Marc Nieto. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    // MARK: - Accessing

    @IBOutlet weak var imageView: UIImageView!
    var initialLocation: CGPoint = .zero
    var image: UIImage?

    // MARK: - Initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.masksToBounds = true
        self.view.layer.cornerRadius = 5.0
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 5.0
        
        if let image = self.image {
            self.imageView.image = image
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ImageViewController.tapHandler(_:)))
        self.imageView.addGestureRecognizer(tapGesture)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.view.bounds = CGRect(origin: .zero, size: CGSize(width: 300.0, height: 300.0))
    }

    // MARK: - Actions

    @objc func tapHandler(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK: - UIViewControllerTransitioningDelegate

extension ImageViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageAnimationController(for: true, source: self)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageAnimationController(for: false, source: self)
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ImagePresentationController(presentedViewController: presented as! ImageViewController, presenting: presenting, source: source)
    }
}
