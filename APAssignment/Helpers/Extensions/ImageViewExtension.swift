//
//  ImageViewExtension.swift
//  APAssignment
//
//  Created by Neha Kukreja on 22/10/24.
//

import Foundation
import UIKit

extension UIImageView {
    func applyTopToBottomRevealAnimation(duration: TimeInterval = 2.0) {
        // Remove any existing mask layers
        self.layer.mask = nil

        // Set up a mask layer to start covering the entire image
        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: 0, y: -self.bounds.height, width: self.bounds.width, height: self.bounds.height)
        self.layer.mask = maskLayer
        
        // Create the reveal animation for the mask
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = -self.bounds.height / 2
        animation.toValue = self.bounds.height / 2
        animation.duration = duration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        // Add the animation to the mask layer
        maskLayer.add(animation, forKey: "revealAnimation")
    }
}
