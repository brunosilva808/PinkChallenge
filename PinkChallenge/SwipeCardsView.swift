//
//  SwipeCardsView.swift
//  PinkChallenge
//
//  Created by Bruno Silva on 05/04/2017.
//  Copyright © 2017 Bruno Silva. All rights reserved.
//

import Foundation
import UIKit

public enum SwipeMode {
    case left
    case right
    case rightTop
    case rightBottom
    case leftTop
    case leftBottom
}

public enum BarButtonColor {
    case red
    case black
}

public protocol SwipeCardsViewDelegate: class {
    func swipedLeft(_ object: Any)
    func swipedRight(_ object: Any)
    func cardTapped(_ object: Any)
    func cardDragged(_ object1: CGFloat,_ object2: CGFloat)
    func changeUIBarButtonColor(color: BarButtonColor)
    func animateUIBarButton(_ xDistance: CGFloat,_ yDistance: CGFloat)
    func reachedEndOfStack()
}

public class SwipeCardsView<Element>: UIView {
    
    public weak var delegate: SwipeCardsViewDelegate?
    public var bufferSize: Int = 2
    
    fileprivate let viewGenerator: ViewGenerator
    fileprivate let overlayGenerator: OverlayGenerator?
    fileprivate var allCards = [Element]()
    fileprivate var loadedCards = [SwipeCard]()
    
    public typealias ViewGenerator = (_ element: Element, _ frame: CGRect) -> (UIView)
    public typealias OverlayGenerator = (_ mode: SwipeMode, _ frame: CGRect) -> (UIView)
    public init(frame: CGRect,
                viewGenerator: @escaping ViewGenerator,
                overlayGenerator: OverlayGenerator? = nil) {
        self.overlayGenerator = overlayGenerator
        self.viewGenerator = viewGenerator
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
    }
    
    override private init(frame: CGRect) {
        fatalError("Please use init(frame:,viewGenerator)")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Please use init(frame:,viewGenerator)")
    }
    
    public func addCards(_ elements: [Element]) {
        guard elements.isEmpty == false else {
            return
        }
        
        self.isUserInteractionEnabled = true


            for element in elements {
                allCards.append(element)
            }
        
        
        if loadedCards.count > 0 {
            for cardView in loadedCards {
                cardView.removeFromSuperview()
            }
            loadedCards.removeAll()
        }
        
        for element in elements {
            if loadedCards.count < bufferSize {
                let cardView = self.createCardView(element: element)
                if loadedCards.isEmpty {
                    self.addSubview(cardView)
                } else {
                    self.insertSubview(cardView, belowSubview: loadedCards.last!)
                }
                self.loadedCards.append(cardView)
            }
        }
    }
    
}

extension SwipeCardsView: SwipeCardDelegate {
    
    func animateUIBarButton(_ xDistance: CGFloat,_ yDistance: CGFloat) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) { 
            self.delegate?.animateUIBarButton(xDistance, yDistance)
        }
    }
    
    func cardSwipedLeft(_ card: SwipeCard) {
        self.handleSwipedCard(card)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            self.delegate?.swipedLeft(card.obj)
            self.loadNextCard()
        }
    }
    
    func cardSwipedRight(_ card: SwipeCard) {
        self.handleSwipedCard(card)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            self.delegate?.swipedRight(card.obj)
            self.loadNextCard()
        }
    }
    
    func cardTapped(_ card: SwipeCard) {
        self.delegate?.cardTapped(card.obj)
    }
    
    func cardDragged(_ xDistance: CGFloat, _ yDistance: CGFloat) {
        self.delegate?.cardDragged(xDistance, yDistance)
    }
    
    func changeUIBarButtonColor(color: BarButtonColor) {
        self.delegate?.changeUIBarButtonColor(color: color)
    }
}

extension SwipeCardsView {
    fileprivate func handleSwipedCard(_ card: SwipeCard) {
        self.loadedCards.removeFirst()
        self.allCards.removeFirst()
        if self.allCards.isEmpty {
            self.isUserInteractionEnabled = false
            self.delegate?.reachedEndOfStack()
        }
    }
    
    fileprivate func loadNextCard() {
        if self.allCards.count - self.loadedCards.count > 0 {
            let next = self.allCards[loadedCards.count]
            let nextView = self.createCardView(element: next)
            let below = self.loadedCards.last!
            self.loadedCards.append(nextView)
            self.insertSubview(nextView, belowSubview: below)
        }
    }
    
    fileprivate func createCardView(element: Element) -> SwipeCard {
        let cardView = SwipeCard(frame: self.bounds)
        cardView.delegate = self
        cardView.obj = element
        let sv = self.viewGenerator(element, cardView.bounds)
        cardView.addSubview(sv)
        cardView.leftOverlay = self.overlayGenerator?(.left, cardView.bounds)
        cardView.leftTopOverlay = self.overlayGenerator?(.leftTop, cardView.bounds)
        cardView.leftBottomOverlay = self.overlayGenerator?(.leftBottom, cardView.bounds)
        cardView.rightOverlay = self.overlayGenerator?(.right, cardView.bounds)
        cardView.rightTopOverlay = self.overlayGenerator?(.rightTop, cardView.bounds)
        cardView.rightBottomOverlay = self.overlayGenerator?(.rightBottom, cardView.bounds)
        cardView.configureOverlays()
        return cardView
    }
}
