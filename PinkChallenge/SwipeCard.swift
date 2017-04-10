//
//  SwipeCards.swift
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
    func cardDragged(_ xDistance: CGFloat,_ yDistance: CGFloat)
    func animateUIBarButton(_ xDistance: CGFloat,_ yDistance: CGFloat)
    func changeUIBarButtonColor(color: BarButtonColor)
}

public let actionMargin: CGFloat = 100.0

class SwipeCard: UIView {
    
    weak var delegate: SwipeCardDelegate?
    var obj: Any!
    var leftOverlay: UIView?
    var rightOverlay: UIView?
    var rightTopOverlay: UIView?
    var rightBottomOverlay: UIView?
    var leftTopOverlay: UIView?
    var leftBottomOverlay: UIView?
    
    private let rotationStrength: CGFloat = 320.0
    private let rotationAngle: CGFloat = CGFloat(Double.pi) / CGFloat(8.0)
    private let rotationMax: CGFloat = 1
    private let scaleStrength: CGFloat = -2
    private let scaleMax: CGFloat = 1.02
    
    private var xFromCenter: CGFloat = 0.0
    private var yFromCenter: CGFloat = 0.0
    private var originalPoint = CGPoint.zero
    private var containersMargin: CGFloat = 80
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragEvent(gesture:)))
        panGesture.delegate = self
        self.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapEvent(gesture:)))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureOverlays() {
        self.configureOverlay(overlay: self.leftOverlay)
        self.configureOverlay(overlay: self.rightOverlay)
        self.configureOverlay(overlay: self.rightTopOverlay)
        self.configureOverlay(overlay: self.rightBottomOverlay)
        self.configureOverlay(overlay: self.leftTopOverlay)
        self.configureOverlay(overlay: self.leftBottomOverlay)
    }
    
    private func configureOverlay(overlay: UIView?) {
        if let o = overlay {
            self.addSubview(o)
            o.alpha = 0.0
        }
    }
    
    func dragEvent(gesture: UIPanGestureRecognizer) {
        xFromCenter = gesture.translation(in: self).x
        yFromCenter = gesture.translation(in: self).y
        
        self.delegate?.cardDragged(xFromCenter, yFromCenter)
        
        switch gesture.state {
        case .began:
            self.originalPoint = self.center
            break
        case .changed:
            let rStrength = min(xFromCenter / self.rotationStrength, rotationMax)
            let rAngle = -self.rotationAngle * rStrength
            let scale = min(1 - fabs(rStrength) / self.scaleStrength, self.scaleMax)
            self.center = CGPoint(x: self.originalPoint.x + xFromCenter, y: self.originalPoint.y + yFromCenter)
            let transform = CGAffineTransform(rotationAngle: rAngle)
            let scaleTransform = transform.scaledBy(x: scale, y: scale)
            self.transform = scaleTransform
            self.updateOverlay(xFromCenter, yFromCenter)
            break
        case .ended:
            self.afterSwipeAction()
            break
        default:
            break
        }
    }
    
    func tapEvent(gesture: UITapGestureRecognizer) {
        self.delegate?.cardTapped(self)
    }
    
    private func afterSwipeAction() {
        if xFromCenter > actionMargin {
            self.rightAction()
        } else if xFromCenter < -actionMargin {
            self.leftAction()
        } else {
            UIView.animate(withDuration: 0.3) {
                self.center = self.originalPoint
                self.transform = CGAffineTransform.identity
                self.leftOverlay?.alpha = 0.0
                self.rightOverlay?.alpha = 0.0
                self.rightTopOverlay?.alpha = 0.0
                self.rightBottomOverlay?.alpha = 0.0
                self.leftTopOverlay?.alpha = 0.0
                self.leftBottomOverlay?.alpha = 0.0
            }
        }
    }
    
    private func updateOverlay(_ xDistance: CGFloat, _ yDistance: CGFloat) {
        
        debugPrint(yDistance)
        self.leftOverlay?.alpha = 0.0
        self.rightOverlay?.alpha = 0.0
        self.rightTopOverlay?.alpha = 0.0
        self.rightBottomOverlay?.alpha = 0.0
        self.leftTopOverlay?.alpha = 0.0
        self.leftBottomOverlay?.alpha = 0.0
        
        var activeOverlay: UIView?
        if xDistance > 0 && yDistance < -self.containersMargin {
            activeOverlay = self.rightTopOverlay
            self.delegate?.changeUIBarButtonColor(color: .red)
        } else if (xDistance > 0 && yDistance > self.containersMargin) {
            activeOverlay = self.rightBottomOverlay
        } else if (xDistance > 0) {
            activeOverlay = self.rightOverlay
        } else if xDistance < 0 && yDistance < -self.containersMargin {
            activeOverlay = self.leftTopOverlay
        } else if xDistance < 0 && yDistance > self.containersMargin {
            activeOverlay = self.leftBottomOverlay
        } else {
            activeOverlay = self.leftOverlay
        }
        
        activeOverlay?.alpha = min(fabs(xDistance)/100, 1.0)
    }
    
    private func rightAction() {
        let finishPoint = CGPoint(x: 500, y: 2 * yFromCenter + self.originalPoint.y)
        UIView.animate(withDuration: 0.3, animations: {
            self.center = finishPoint
        }) { _ in
            self.removeFromSuperview()
        }
        self.delegate?.cardSwipedRight(self)
        self.delegate?.animateUIBarButton(finishPoint.x, finishPoint.y)
    }
    
    private func leftAction() {
        let finishPoint = CGPoint(x: -500, y: 2 * yFromCenter + self.originalPoint.y)
        UIView.animate(withDuration: 0.3, animations: {
            self.center = finishPoint
        }) { _ in
            self.removeFromSuperview()
        }
        self.delegate?.cardSwipedLeft(self)
    }
}

extension SwipeCard: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
