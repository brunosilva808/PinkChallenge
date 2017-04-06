//
//  ViewController.swift
//  PinkChallenge
//
//  Created by Bruno Silva on 05/04/2017.
//  Copyright © 2017 Bruno Silva. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SwipeCardsViewDelegate {

    // MARK: - Var
    
    private var swipeView: SwipeCardsView<String>!
    private var count = 0
    let emojiLauncher = EmojiLauncher()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        let viewGenerator: (String, CGRect) -> (UIView) = { (element: String, frame: CGRect) -> (UIView) in
            let container = UIView(frame: CGRect(x: 30, y: 20, width: frame.width - 60, height: frame.height - 60))
            let label = UILabel(frame: container.bounds)
            label.text = element
            label.textAlignment = .center
            label.backgroundColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 48, weight: UIFontWeightThin)
            label.clipsToBounds = true
            label.layer.cornerRadius = 16
            container.addSubview(label)
            
            container.layer.shadowRadius = 4
            container.layer.shadowOpacity = 1.0
            container.layer.shadowColor = UIColor(white: 0.9, alpha: 1.0).cgColor
            container.layer.shadowOffset = CGSize(width: 0, height: 0)
            container.layer.shouldRasterize = true
            container.layer.rasterizationScale = UIScreen.main.scale
            
            return container
        }
    
        let overlayGenerator: (SwipeMode, CGRect) -> (UIView) = { (mode: SwipeMode, frame: CGRect) -> (UIView) in
            let label = UILabel()
            label.frame.size = CGSize(width: 100, height: 100)
            label.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
            label.layer.cornerRadius = label.frame.width / 2
            label.backgroundColor = mode == .left ? UIColor.red : UIColor.green
            label.clipsToBounds = true
            label.text = mode == .left ? "👎" : "👍"
            label.font = UIFont.systemFont(ofSize: 24)
            label.textAlignment = .center
            return label
        }
        
        let frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height - 160)
        swipeView = SwipeCardsView<String>(frame: frame,
                                             viewGenerator: viewGenerator,
                                             overlayGenerator: overlayGenerator)
        swipeView.delegate = self
        self.view.addSubview(swipeView)
        
        self.swipeView.addCards((self.count...(self.count+19)).map({"\($0)"}), onTop: true)
        self.count = self.count + 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - SwipeCardsDelegate
    
    func swipedLeft(_ object: Any) {
        print("Swiped left: \(object)")
        emojiLauncher.dismissEmojiViews()
    }
    
    func swipedRight(_ object: Any) {
        print("Swiped right: \(object)")
        emojiLauncher.dismissEmojiViews()
    }
    
    func cardTapped(_ object: Any) {
        print("Tapped on: \(object)")
        emojiLauncher.dismissEmojiViews()
    }
    
    func reachedEndOfStack() {
        print("Reached end of stack")
        emojiLauncher.dismissEmojiViews()
    }
    
    func cardDragged(_ xDistance: CGFloat,_ yDistance: CGFloat) {
        
        if xDistance > actionMargin {
            emojiLauncher.showRightEmojiView(yDistance: yDistance)
        } else if xDistance < -actionMargin {
            emojiLauncher.showLeftEmojiView()
        } else {
            emojiLauncher.dismissEmojiViews()
        }
        
//        print("Card Dragged X: \(xDistance)")
//        print("Card Dragged Y: \(yDistance)")
    }

}

//extension ViewController: SwipeCardsViewDelegate {
//    func swipedLeft(_ object: Any) {
//        print("Swiped left: \(object)")
//    }
//    
//    func swipedRight(_ object: Any) {
//        print("Swiped right: \(object)")
//    }
//    
//    func cardTapped(_ object: Any) {
//        print("Tapped on: \(object)")
//    }
//    
//    func reachedEndOfStack() {
//        print("Reached end of stack")
//    }
//
//    func cardDragged(_ object: CGFloat) {
//        let emojiLauncher = EmojiLauncher()
//        emojiLauncher.showEmojiView()
//        
//        if object > actionMargin {
//            debugPrint("Right")
//        } else if object < -actionMargin {
//            debugPrint("Left")
//        } else {
//            emojiLauncher.dismissEmojiView()
//        }
//        
//        print("Card Dragged distance: \(object)")
//    }
//}
