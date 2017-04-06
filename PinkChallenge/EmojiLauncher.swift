//
//  EmojiLauncher.swift
//  PinkChallenge
//
//  Created by Bruno Silva on 06/04/2017.
//  Copyright © 2017 Bruno Silva. All rights reserved.
//

import UIKit

public enum emojiSide {
    case left
    case right
}

class EmojiLauncher: NSObject {
    
    let rightViewContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    let leftViewContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    let emojiHappy1Image: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "emojiHappy1")
        imageView.alpha = 0.5
        return imageView
    }()

    let emojiHappy2Image: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "emojiHappy2")
        imageView.alpha = 0.5
        return imageView
    }()

    let emojiHappy3Image: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "emojiHappy3")
        imageView.alpha = 0.5
        return imageView
    }()
    
    let emojiSad1Image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "emojiSad1")
        imageView.alpha = 0.5
        return imageView
    }()
    
    let emojiSad2Image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "emojiSad2")
        imageView.alpha = 0.5
        return imageView
    }()
    
    let emojiSad3Image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "emojiSad3")
        imageView.alpha = 0.5
        return imageView
    }()
    
    func showRightEmojiView(yDistance: CGFloat) {
        debugPrint("showRightEmojiView")
        if let window = UIApplication.shared.keyWindow {
            let height = CGFloat(300)
            let width = ( window.frame.width / 2 ) - 60
            
            window.addSubview(self.rightViewContainer)
            
            self.rightViewContainer.frame = CGRect(x: window.frame.width - width,
                                              y: ( window.frame.height / 2 ) - ( height / 2 ),
                                              width: ( window.frame.width / 2 ) - 60,
                                              height: height)
            self.rightViewContainer.alpha = 1
            
            self.rightViewContainer.addSubview(emojiHappy1Image)
            self.rightViewContainer.addSubview(emojiHappy2Image)
            self.rightViewContainer.addSubview(emojiHappy3Image)
            
            self.rightViewContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: emojiHappy1Image)
            self.rightViewContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: emojiHappy2Image)
            self.rightViewContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: emojiHappy3Image)
            
            let emojiHeight = height / 3

            self.rightViewContainer.addConstraintsWithFormat(format: "V:|[v0(" + "\((emojiHeight))" + ")]-[v1(" + "\((emojiHeight))" + ")]-[v2(" + "\((emojiHeight))" + ")]", views: emojiHappy1Image, emojiHappy2Image, emojiHappy3Image)
            
            showEmoji(height: emojiHeight, yDistance: yDistance, side: .right)
        }
    }
    
    func showLeftEmojiView(yDistance: CGFloat) {
        debugPrint("showLeftEmojiView")
        if let window = UIApplication.shared.keyWindow {
            let height = CGFloat(300)
            window.addSubview(self.leftViewContainer)
            
            self.leftViewContainer.frame = CGRect(x: 0,
                                              y: ( window.frame.height / 2 ) - ( height / 2 ),
                                              width: ( window.frame.width / 2 ) - 60,
                                              height: height)
//            self.leftViewContainer.alpha = 0
//            
//            UIView.animate(withDuration: 0.3, animations: {
                self.leftViewContainer.alpha = 1
//            })
            
            self.leftViewContainer.addSubview(emojiSad1Image)
            self.leftViewContainer.addSubview(emojiSad2Image)
            self.leftViewContainer.addSubview(emojiSad3Image)
            
            self.leftViewContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: emojiSad1Image)
            self.leftViewContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: emojiSad2Image)
            self.leftViewContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: emojiSad3Image)
            
            let emojiHeight = height / 3
            
            self.leftViewContainer.addConstraintsWithFormat(format: "V:|[v0(" + "\((emojiHeight))" + ")]-[v1(" + "\((emojiHeight))" + ")]-[v2(" + "\((emojiHeight))" + ")]", views: emojiSad1Image, emojiSad2Image, emojiSad3Image)
            
            debugPrint("Y: " + "\(yDistance)")
            showEmoji(height: emojiHeight, yDistance: yDistance,side: .left)
        }
    }
    
    func showEmoji(height: CGFloat, yDistance: CGFloat, side: emojiSide) {
        
        emojiSad1Image.alpha = 0.5
        emojiSad2Image.alpha = 0.5
        emojiSad3Image.alpha = 0.5
        
        emojiHappy1Image.alpha = 0.5
        emojiHappy2Image.alpha = 0.5
        emojiHappy3Image.alpha = 0.5

        let topEmoji = -( height / 3 ) + 20
        let bottomEmoji = ( height / 3 ) - 20
        
        if topEmoji > yDistance  {
            switch side {
            case .left:
                emojiSad1Image.alpha = 1
            case .right:
                emojiHappy1Image.alpha = 1
            }
        } else if bottomEmoji > yDistance {
            switch side {
            case .left:
                emojiSad2Image.alpha = 1
            case .right:
                emojiHappy2Image.alpha = 1
            }
        } else if yDistance > bottomEmoji {
            switch side {
            case .left:
                emojiSad3Image.alpha = 1
            case .right:
                emojiHappy3Image.alpha = 1
            }
        }
    }
    
    func dismissEmojiViews() {
        UIView.animate(withDuration: 0.3, animations: {
            self.rightViewContainer.alpha = 0
            self.leftViewContainer.alpha = 0
        })
    }
    
    override init() {
        super.init()
    }
}
