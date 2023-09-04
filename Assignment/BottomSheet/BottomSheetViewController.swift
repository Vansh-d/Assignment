//
//  BottomSheetViewController.swift
//  Assignment
//
//  Created by Vansh Dubey on 31/08/23.
//

import UIKit

class BottomSheetViewController: UIViewController {
    
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var contentViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var contentViewHeight: NSLayoutConstraint!
    
    private let childViewController: UIViewController
    private var originBeforeAnimation: CGRect = .zero

    override public func viewDidLoad() {
            super.viewDidLoad()
            contentView.alpha = 1
            configureChild()
            
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(BottomSheetViewController.panGesture))
            contentView.addGestureRecognizer(gesture)
            
            contentViewBottomConstraint.constant = -childViewController.view.frame.height
            view.layoutIfNeeded()
     }
        
    override public func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            
            contentViewHeight.isActive = false
            
            contentViewBottomConstraint.constant = 0
            UIView.animate(withDuration: 0.6) {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                self.view.layoutIfNeeded()
            }
    }
        
    override public func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            contentView.roundCorners([.topLeft, .topRight], radius: 15)
            originBeforeAnimation = contentView.frame
    }
    public init(childViewController: UIViewController) {
            self.childViewController = childViewController
            super.init(
                nibName: String(describing: BottomSheetViewController.self),
                bundle: Bundle(for: BottomSheetViewController.self)
            )
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    func dismissViewController() {
            contentViewBottomConstraint.constant = -childViewController.view.frame.height
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
                self.view.backgroundColor = .clear
            }, completion: { _ in
                self.dismiss(animated: false, completion: nil)
            })
        }
    
    private func configureChild() {
            addChild(childViewController)
            contentView.addSubview(childViewController.view)
            childViewController.didMove(toParent: self)
            
            guard let childSuperView = childViewController.view.superview else { return }

            NSLayoutConstraint.activate([
                childViewController.view.bottomAnchor.constraint(equalTo: childSuperView.bottomAnchor),
                childViewController.view.topAnchor.constraint(equalTo: childSuperView.topAnchor),
                childViewController.view.leftAnchor.constraint(equalTo: childSuperView.leftAnchor),
                childViewController.view.rightAnchor.constraint(equalTo: childSuperView.rightAnchor)
                ])
            
            childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        private func shouldDismissWithGesture(_ recognizer: UIPanGestureRecognizer) -> Bool {
            return recognizer.state == .ended
        }
        
        @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
            let point = recognizer.location(in: view)
            
            if shouldDismissWithGesture(recognizer) {
                dismissViewController()
            } else {
                if point.y <= originBeforeAnimation.origin.y {
                    recognizer.isEnabled = false
                    recognizer.isEnabled = true
                    return
                }
                contentView.frame = CGRect(x: 0, y: point.y, width: view.frame.width, height: view.frame.height)
            }
        }
        
        private func containsTableView() -> UITableView? {
            for view in childViewController.view.subviews {
                if let tableView = view as? UITableView {
                    return tableView
                }
            }
            return nil
        }
    
    
    public func gestureRecognizer(
            _ gestureRecognizer: UIGestureRecognizer,
            shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
            ) -> Bool {
            
            return false
        }
        
        @IBAction private func topViewTap(_ sender: Any) {
            dismissViewController()
        }

}


public extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let roundedLayer = CAShapeLayer()
        roundedLayer.path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
            ).cgPath
        layer.mask = roundedLayer
    }
    
    func fadeTo(
        _ alpha: CGFloat,
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        completion: (() -> Void)? = nil) {
        
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: .curveEaseInOut,
            animations: {
                self.alpha = alpha
        },
            completion: nil
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion?()
        }
    }
    
    func fadeIn(duration: TimeInterval = 0.3, delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        fadeTo(1, duration: duration, delay: delay, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.3, delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        fadeTo(0, duration: duration, delay: delay, completion: completion)
    }
}



extension UIViewController {
    func presentBottomSheet(_ bottomSheet: BottomSheetViewController, completion: (() -> Void)?) {
        self.present(bottomSheet, animated: false, completion: completion)
    }
}

