//
//  AnimatorFactory.swift
//

import UIKit

public class AnimatorFactory {
    public static func scaleUp(view: UIView) -> UIViewPropertyAnimator {
        let scale = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut)
        scale.addAnimations({
            guard let superView = view.superview else { return }
            let scaleFactor = CGFloat(superView.frame.size.width/view.frame.size.height)
            view.transform = CGAffineTransform.identity.scaledBy(x: scaleFactor, y: scaleFactor)
            if (view.center == superView.center) {
                view.frame.origin.y = superView.safeAreaInsets.top
            } else {
                view.center = superView.center
            }
        }, delayFactor: 0)
        return scale
    }
}
