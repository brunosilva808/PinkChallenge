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
}

public protocol SwipeCardsViewDelegate: class {
    func swipedLeft(_ object: Any)
    func swipedRight(_ object: Any)
    func cardTapped(_ object: Any)
    func reachedEndOfStack()
}

class SwipeCardsView<Element>: UIView {

    //MARK: - VAR
    
    public weak var delegate: SwipeCardsViewDelegate?
    public var bufferSize: Int = 2
    
    fileprivate let viewGenerator: ViewGenerator
    fileprivate let overlayGenerator: OverlayGenerator?
    
    fileprivate var allCards = [Element]()
    fileprivate var loadedCards = [SwipeCard]()

    public typealias ViewGenerator = (_ element: Element, _ frame: CGRect) -> (UIView)
    public typealias OverlayGenerator = (_ mode: SwipeMode, _ frame: CGRect) -> (UIView)
    
    //MARK: - Life Cycle
    
    public init(frame: CGRect,
                viewGenerator: @escaping ViewGenerator,
                overlayGenerator: OverlayGenerator? = nil){
        // May only be initialized once
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
    
    //MARK: - Class Logic
    
    public func addCards(_ elements: [Element], onTop: Bool = false) {
        guard elements.isEmpty == false else {
            return
        }
        
        self.isUserInteractionEnabled = true
        
        if onTop {
            for element in elements {
                allCards.insert(element, at: 0)
            }
        } else {
            for element in elements {
                allCards.append(element)
            }
        }
        
        if onTop == true && self.loadedCards.count > 0 {
            for cardView in self.loadedCards {
                cardView.removeFromSuperview()
            }
            self.loadedCards.removeAll()
        }
        
        for element in elements {
            if self.loadedCards.count < bufferSize {
                let cardView = self.createCardView(element: element)
                
                if self.loadedCards.isEmpty {
                    self.addSubview(cardView)
                } else {
                    self.insertSubview(cardView, belowSubview: loadedCards.last!)
                }
                self.loadedCards.append(cardView)
            }
        }
    }
    
}

// Delegate Methods
extension SwipeCardsView: SwipeCardDelegate {
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
    
    fileprivate func loadNextCard(){
        if self.allCards.count - self.loadedCards.count > 0 {
            let next = self.allCards[loadedCards.count]
            let nextView = self.createCardView(element: next)
            self.loadedCards.append(nextView)
            self.insertSubview(nextView, belowSubview: self.loadedCards.last!)
        }
    }
    
    func createCardView(element: Element) -> SwipeCard {
        let cardView = SwipeCard(frame: self.bounds)
        cardView.delegate = self
        cardView.obj = element
        let sv = self.viewGenerator(element, cardView.bounds)
        cardView.addSubview(sv)
        cardView.leftOverlay = self.overlayGenerator?(.left, cardView.bounds)
        cardView.rightOverlay = self.overlayGenerator?(.right, cardView.bounds)
        cardView.configureOverlays()
        return cardView
    }
}
