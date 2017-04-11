//
//  ViewController.swift
//  PinkChallenge
//
//  Created by Bruno Silva on 05/04/2017.
//  Copyright © 2017 Bruno Silva. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, SwipeCardsViewDelegate {
    // MARK: - Var
    
    private var swipeView: SwipeCardsView<String>!
    private var count = 0
    var emojiLauncher = EmojiLauncher()
    
    var heartBarButtonItem = UIBarButtonItem()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        setupNavBarUI()
        setupNavBarTitle()
        setupNavBarButtons()
        
        let viewGenerator = setupCard()
        let overlayGenerator = setupOverlay()

        setupSwipeView(viewGenerator: viewGenerator, overlayGenerator: overlayGenerator)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Setup
    
    func setupCard() -> (String, CGRect) -> (UIView) {
        let viewGenerator: (String, CGRect) -> (UIView) = { (element: String, frame: CGRect) -> (UIView) in
            let container = UIView(frame: CGRect(x: 30, y: 20, width: frame.width - 60, height: frame.height - 60))
            let label = UILabel(frame: container.bounds)
            //label.text = element
            //            label.textAlignment = .center
            label.backgroundColor = UIColor.white
            //            label.font = UIFont.systemFont(ofSize: 48, weight: UIFontWeightThin)
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
        
        return viewGenerator
    }
    
    func setupOverlay() -> (SwipeMode, CGRect) -> (UIView) {
        let overlayGenerator: (SwipeMode, CGRect) -> (UIView) = { (mode: SwipeMode, frame: CGRect) -> (UIView) in
            let label = UILabel()
            label.frame.size = CGSize(width: 100, height: 100)
            label.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
            label.layer.cornerRadius = label.frame.width / 2
            label.clipsToBounds = true
            //            label.backgroundColor = mode == .left ? UIColor.red : UIColor.green
            //            label.text = mode == .left ? "👎" : "👍"
            
            switch mode {
            case .left:
                label.text = "👎"
                label.backgroundColor = UIColor.red
            case .right:
                label.text = "👍"
                label.backgroundColor = UIColor.green
            case .rightTop:
                label.text = "Right Top"
                label.backgroundColor = UIColor.green
            case .rightBottom:
                label.text = "Right Bottom"
                label.backgroundColor = UIColor.green
            case .leftTop:
                label.text = "Left Top"
                label.backgroundColor = UIColor.red
            case .leftBottom:
                label.text = "Left Bottom"
                label.backgroundColor = UIColor.red
            }
            
            label.font = UIFont.systemFont(ofSize: 14)
            label.textAlignment = .center
            return label
        }
        
        return overlayGenerator
    }
    
    func setupSwipeView(viewGenerator: @escaping (String, CGRect) -> (UIView),
                        overlayGenerator: @escaping (_ mode: SwipeMode, _ frame: CGRect) -> (UIView)) {
        let frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height - 160)
        swipeView = SwipeCardsView<String>(frame: frame,
                                           viewGenerator: viewGenerator,
                                           overlayGenerator: overlayGenerator)
        swipeView.delegate = self
        self.view.addSubview(swipeView)
        
        self.swipeView.addCards((self.count...(self.count+19)).map({"\($0)"}))
        self.count = self.count + 20
    }
    
    func setupNavBarUI() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    func setupNavBarTitle() {
        let label = UILabel(frame: CGRect(x:0, y:0, width:400, height:50))
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        label.text = "How do you like \nthis one?"
        self.navigationItem.titleView = label
    }
    
    func setupNavBarButtons(){
        let burguerMenuImage = #imageLiteral(resourceName: "burguerMenu").withRenderingMode(.alwaysOriginal)
        let burguerMenuBarButtonItem = UIBarButtonItem(image: burguerMenuImage, style: .plain, target: self, action: nil)
        
        navigationItem.leftBarButtonItem = burguerMenuBarButtonItem
        
        let icon = #imageLiteral(resourceName: "heartMenu").withRenderingMode(.alwaysOriginal)
        let iconSize = CGRect(origin: CGPoint.zero, size: icon.size)
        let iconButton = UIButton(frame: iconSize)
        iconButton.setBackgroundImage(icon, for: .normal)
        
        self.heartBarButtonItem.customView = iconButton
        navigationItem.rightBarButtonItem = self.heartBarButtonItem
        
        self.heartBarButtonItem.customView!.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 1.0,
                                   delay: 0.5,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 10,
                                   options: .curveLinear,
                                   animations: {
                                    self.heartBarButtonItem.customView!.transform = CGAffineTransform.identity
        },
                                   completion: nil
        )
        
    }
    
    // MARK: IBAction
    
    func changeUIBarButtonColor(color: BarButtonColor) {
        
        var icon = UIImage()
        
        switch color {
        case .red:
            icon = #imageLiteral(resourceName: "heartRedMenu").withRenderingMode(.alwaysOriginal)
        case .black:
            icon = #imageLiteral(resourceName: "heartMenu").withRenderingMode(.alwaysOriginal)
        }
        
        let iconSize = CGRect(origin: CGPoint.zero, size: icon.size)
        let iconButton = UIButton(frame: iconSize)
        iconButton.setBackgroundImage(icon, for: .normal)
        
        self.heartBarButtonItem.customView = iconButton
    }
    
    func animateUIBarButton(completion: @escaping () -> ()) {
        self.heartBarButtonItem.customView!.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 6/5))
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.heartBarButtonItem.customView!.transform = CGAffineTransform.identity
        }) { (response) in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    //MARK: - SwipeCardsDelegate
    
    func animateUIBarButton(_ xDistance: CGFloat, _ yDistance: CGFloat) {
        if -actionMargin + 20 > yDistance && xDistance > 0 {
            animateUIBarButton(completion: { 
                self.changeUIBarButtonColor(color: .black)
            })
        }
    }
    
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
        changeUIBarButtonColor(color: .black)
        emojiLauncher.dismissEmojiViews()
    }
    
    func cardDragged(_ xDistance: CGFloat,_ yDistance: CGFloat) {
        
        if xDistance > actionMargin {
            emojiLauncher.showRightEmojiView(yDistance: yDistance)
        } else if xDistance < -actionMargin {
            emojiLauncher.showLeftEmojiView(yDistance: yDistance)
        } else {
            emojiLauncher.dismissEmojiViews()
        }
        
//        print("Card Dragged X: \(xDistance)")
//        print("Card Dragged Y: \(yDistance)")
    }

}
