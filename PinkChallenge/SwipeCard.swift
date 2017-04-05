//
//  SwipeCard.swift
//  PinkChallenge
//
//  Created by Bruno Silva on 05/04/2017.
//  Copyright © 2017 Bruno Silva. All rights reserved.
//

import Foundation
import UIKit

protocol SwipeCardDelegate: class {
    func cardSwipedLeft(_ card: SwipeCard)
    func cardSwipedRight(_ card: SwipeCard)
    func cardTapped(_ card: SwipeCard)
}

class SwipeCard: UIView {
    
    // MARK: - Var
    weak var delegate: SwipeCardDelegate?
    var obj: Any!
    var leftOverlay: UIView?
    var rightOverlay: UIView?
    
    private var xFromCenter: CGFloat = 0.0
    private var yFromCenter: CGFloat = 0.0
    private var originalPoint = CGPoint.zero
    private let rotationStrength: CGFloat = 320.0
    private let rotationMax: CGFloat = 1
    private let rotationAngle: CGFloat = CGFloat(Double.pi) / CGFloat(8.0)
    private let scaleStrength: CGFloat = -2
    private let scaleMax: CGFloat = 1.02
    private let actionMargin: CGFloat = 120.0
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupGestures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overlay
    
    func configureOverlays() {
        self.configureOverlay(overlay: self.leftOverlay)
        self.configureOverlay(overlay: self.rightOverlay)
    }
    
    private func configureOverlay(overlay: UIView?) {
        if let o = overlay {
            self.addSubview(o)
            o.alpha = 0.0
        }
    }
    
    // MARK: - Setup
    
    func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragEvent(gesture:)))
        self.addGestureRecognizer(panGesture)
        
        let tapGesture = UIPanGestureRecognizer(target: self, action: #selector(tapEvent(gesture:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Gesture
    
    func dragEvent(gesture: UIPanGestureRecognizer) {
        xFromCenter = gesture.translation(in: self).x
        yFromCenter = gesture.translation(in: self).y
        
        switch gesture.state {
        case .began:
            originalPoint = self.center
        case .changed:
            // Rotation
            let rStrength = min(xFromCenter / rotationStrength, rotationMax)
            let rAngle = self.rotationAngle * rStrength
            let scale = min(1 - fabs(rStrength) / self.scaleStrength, self.scaleMax)
            // Center
            self.center = CGPoint(x: self.originalPoint.x + xFromCenter, y: self.originalPoint.y + yFromCenter)
            // Transform
            let transform = CGAffineTransform(rotationAngle: rAngle)
            let scaleTransform = transform.scaledBy(x: scale, y: scale)
            self.transform = scaleTransform
            break
        case .ended:
            self.afterSwipeAction()
        default:
            break
        }
    }
    
    func tapEvent(gesture: UIPanGestureRecognizer) {
        self.delegate?.cardTapped(self)
    }
    
    func afterSwipeAction() {
        if xFromCenter > actionMargin {
            self.rightAction()
        } else if xFromCenter < -actionMargin {
            self.leftAction()
        } else {
            self.center = self.originalPoint
            self.transform = CGAffineTransform.identity
            self.rightOverlay?.alpha = 0.0
            self.leftOverlay?.alpha = 0.0
        }
    }
    
    //MARK: Class Logic
    
    func rightAction() {
        let finishPoint = CGPoint(x: 500, y: 2 * yFromCenter + self.originalPoint.y)
        UIView.animate(withDuration: 0.3, animations: { 
            self.center = finishPoint
        }) { _ in
            self.removeFromSuperview()
        }
        self.delegate?.cardSwipedRight(self)
    }

    func leftAction() {
        let finishPoint = CGPoint(x: 500, y: 2 * yFromCenter + self.originalPoint.y)
        UIView.animate(withDuration: 0.3, animations: {
            self.center = finishPoint
        }) { _ in
            self.removeFromSuperview()
        }
        self.delegate?.cardSwipedLeft(self)
    }
}

extension SwipeCard: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        return true
    }
}
