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
    
    let reactLabel: UILabel = {
        let label = UILabel()
        label.text = "REACT"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let happyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "emojiHappy1")
        return imageView
    }()
    
    let sadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "emojiSad1")
        return imageView
    }()
    
    let leftArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "leftArrow")
        return imageView
    }()
    
    let rightArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "rightArrow")
        return imageView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        setupUI()
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
            container.layer.shadowRadius = 4
            container.layer.shadowOpacity = 1.0
            container.layer.shadowColor = UIColor(white: 0.9, alpha: 1.0).cgColor
            container.layer.shadowOffset = CGSize(width: 0, height: 0)
            container.layer.shouldRasterize = true
            container.layer.rasterizationScale = UIScreen.main.scale
            
            let label = UILabel(frame: container.bounds)
            label.backgroundColor = UIColor.white
            label.clipsToBounds = true
            label.layer.cornerRadius = 16
            container.addSubview(label)
            
            let titleLabel = UILabel()
            titleLabel.text = "Thing Pink Challenge"
            container.addSubview(titleLabel)
            
            let subTitleLabel = UILabel()
            subTitleLabel.text = "Sub Title"
            subTitleLabel.font = UIFont.systemFont(ofSize: 14)
            container.addSubview(subTitleLabel)
            
            let imageView = UIImageView()
            imageView.image = #imageLiteral(resourceName: "thingPink")
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 10
            
            container.addSubview(imageView)
            container.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: imageView)
            container.addConstraintsWithFormat(format: "V:|-16-[v0]-16-[v1(31)][v2(31)]-16-|", views: imageView, titleLabel, subTitleLabel)
            container.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: titleLabel)
            container.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: subTitleLabel)
            
            return container
        }
        
        return viewGenerator
    }
    
    func setupOverlay() -> (SwipeMode, CGRect) -> (UIView) {
        let overlayGenerator: (SwipeMode, CGRect) -> (UIView) = { (mode: SwipeMode, frame: CGRect) -> (UIView) in
            var label = UILabel()
            label.layer.cornerRadius = 10
            label.clipsToBounds = true
            label.font = UIFont.systemFont(ofSize: 14)
            label.textAlignment = .center
            
            switch mode {
            case .left:
                label = self.setupRightLabel(label: label, frame: frame, title: "👎")
            case .right:
                label = self.setupLeftLabel(label: label, frame: frame, title: "👍")
            case .rightTop:
                label = self.setupLeftLabel(label: label, frame: frame, title: "Right Top")
            case .rightBottom:
                label = self.setupLeftLabel(label: label, frame: frame, title: "Right Bottom")
            case .leftTop:
                label = self.setupRightLabel(label: label, frame: frame, title: "Left Top")
            case .leftBottom:
                label = self.setupRightLabel(label: label, frame: frame, title: "Left Bottom")
            }
            
            return label
        }
        
        return overlayGenerator
    }
    
    func setupRightLabel(label: UILabel, frame: CGRect, title: String) -> UILabel {
        label.text = title
        let labelWidth = CGFloat(100)
        label.frame = CGRect(x: frame.width - labelWidth - 30, y: 20, width: labelWidth, height: 30)
        label.backgroundColor = UIColor.red
        
        return label
    }
    
    func setupLeftLabel(label: UILabel, frame: CGRect, title: String) -> UILabel {
        label.text = title
        label.backgroundColor = UIColor.green
        label.frame = CGRect(x: 30, y: 20, width: 100, height: 30)
        label.backgroundColor = UIColor.green
        
        return label
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
    
    func setupUI() {
        self.view.addSubview(self.reactLabel)
        self.view.addSubview(self.sadImageView)
        self.view.addSubview(self.happyImageView)
        self.view.addSubview(self.leftArrowImageView)
        self.view.addSubview(self.rightArrowImageView)
        
        let xConstraint = NSLayoutConstraint(item: self.reactLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([xConstraint])
        
        self.view.addConstraintsWithFormat(format: "H:[v0]-16-[v1(22)]-16-[v2]-16-[v3(22)]-16-[v4]", views: self.leftArrowImageView, self.sadImageView, self.reactLabel, self.happyImageView, rightArrowImageView)
        self.view.addConstraintsWithFormat(format: "V:[v0]-16-|", views: self.reactLabel)
        self.view.addConstraintsWithFormat(format: "V:[v0(22)]-16-|", views: self.sadImageView)
        self.view.addConstraintsWithFormat(format: "V:[v0(22)]-16-|", views: self.happyImageView)
        self.view.addConstraintsWithFormat(format: "V:[v0(22)]-16-|", views: self.leftArrowImageView)
        self.view.addConstraintsWithFormat(format: "V:[v0(22)]-16-|", views: self.rightArrowImageView)
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
    
    //MARK: - SwipeCardsDelegate
    
    func transformUIBarButton(_ xDistance: CGFloat, _ yDistance: CGFloat) {
        self.heartBarButtonItem.customView!.transform = CGAffineTransform(scaleX: 2, y: 2)
    }
    
    func animateUIBarButton(_ xDistance: CGFloat, _ yDistance: CGFloat) {
        // Rotation
//        self.heartBarButtonItem.customView!.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 6/5))
        // Scale
        self.heartBarButtonItem.customView!.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        if -actionMargin + 20 > yDistance && xDistance > 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.heartBarButtonItem.customView!.transform = CGAffineTransform.identity
            }) { (response) in
                self.changeUIBarButtonColor(color: .black)
            }
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
