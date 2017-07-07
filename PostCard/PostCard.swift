//
//  PostCard.swift
//  PostCard
//
//  Created by Matthew Russo on 6/20/17.
//  Copyright © 2017 Olya Danylova. All rights reserved.
//

import UIKit

@IBDesignable class PostCard: UIView {
    private let appId = "63E6BEB9-AC2E-0B24-FF2C-F948484DAB00"
    private let restKey = "EF808C18-6125-4C6F-FFEA-72F6D8807800"
    var id: String?
    var country: String?
    var dateString: String?
    var city: String?
    var text: String?
    var image: UIImage?
    var front = UIImageView()
    var back = UIView()
    var frontShown = true
    
    init(frame: CGRect,id: String, country: String, city: String, text: String, dateString: String, image: UIImage) {
        self.id = id
        self.country = country
        self.city = city
        self.text = text
        self.dateString = dateString
        self.image = image
        super.init(frame: frame)
        setUpViews()

    }

    required init?(coder : NSCoder) {
        super.init(coder: coder)
        
        setUpViews()
    }
    

    func setUpViews() {
        
        setUpCard()

        insertSubview(front, at: 0)
    }


    func setUpCard() {
        let viewFrame = self.bounds
        let cardWidth = CGFloat(viewFrame.size.width)
        let cardHeight = CGFloat(viewFrame.size.height)
        let widthWithMargins = cardWidth - 40
        let textColor =  UIColor.white
        let textColorBack =  UIColor(red:0.30, green:0.30, blue:0.30, alpha:1.0)
        var id2: String = id!
        id2 = id2.replacingOccurrences(of: "\"", with: "")

        // Front Set Up
        front.frame = CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight)
        front.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        front.image = image
//        front.contentMode = .scaleAspectFill
//        front.clipsToBounds = true

        let labelYPosn = CGFloat(cardHeight - 120)
        let label = UILabel(frame: CGRect(x: 20, y: labelYPosn, width: widthWithMargins, height: 50))
        let border = UIView(frame: CGRect(x: 0, y: -45, width: widthWithMargins, height: 5))
        border.backgroundColor = textColor
        
        label.text = city
        label.textColor = textColor
        label.font = UIFont.boldSystemFont(ofSize: 44)
        label.adjustsFontSizeToFitWidth = true
        
        let countryLabel = UILabel()
        countryLabel.text = country
        countryLabel.sizeToFit()
        let countryWidth =  countryLabel.bounds.size.width
        let countryHeight =  countryLabel.bounds.size.height
        countryLabel.textColor = textColor
        countryLabel.frame = CGRect(x: 0, y:-39, width: countryWidth, height: countryHeight)
        
        let dateLabel = UILabel()
        dateLabel.text = dateString
        dateLabel.sizeToFit()
        let dateLabelWidth =  dateLabel.bounds.size.width
        let dateLabelHeight =  dateLabel.bounds.size.height
        let dateLabelXPosn = countryWidth + 10
        dateLabel.textColor = UIColor(white:1.0, alpha:0.45)
        dateLabel.frame = CGRect(x: dateLabelXPosn, y:-39, width: dateLabelWidth, height: dateLabelHeight)

        
        let closeX = UILabel()
        closeX.text = "✕"
        closeX.font = UIFont.systemFont(ofSize: 50)
        closeX.textColor = textColor
        closeX.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        closeX.textAlignment = .center
        let closeFrontXPosn = widthWithMargins - 30
        let closeFront = UIButton(frame: CGRect(x: closeFrontXPosn, y: 35, width: 40, height: 40))
        closeFront.backgroundColor = UIColor.clear
        closeFront.addSubview(closeX)
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = front.frame
        let transparentBlack = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7).cgColor
        gradient.colors = [transparentBlack, UIColor.clear.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        
        front.layer.insertSublayer(gradient, at: 0)
        
        label.addSubview(border)
        label.addSubview(countryLabel)
        label.addSubview(dateLabel)
        front.addSubview(label)
        front.addSubview(closeFront)
        
        // Back Set Up
        
        let backCloseX = UILabel()
        backCloseX.text = "✕"
        backCloseX.font = UIFont.systemFont(ofSize: 50)
        backCloseX.textColor = textColorBack
        backCloseX.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 0.0)
        backCloseX.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        backCloseX.textAlignment = .center

        let closeBack = UIButton(frame: CGRect(x: closeFrontXPosn, y: 35, width: 40, height: 40))
        closeBack.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 0.0)
        
        let backLabel = UILabel()
        backLabel.text = city
        backLabel.adjustsFontSizeToFitWidth = true
        backLabel.frame = CGRect(x: 20, y: 90, width: widthWithMargins, height: 42)
        backLabel.textColor = textColorBack
        backLabel.font = UIFont.boldSystemFont(ofSize: 42)

        let backText = UITextView(frame: CGRect(x: 20, y: 160, width: widthWithMargins, height: 400))
        backText.text = text
        backText.textColor = textColorBack
        backText.isUserInteractionEnabled = false
        backText.font = UIFont.systemFont(ofSize: 16)
    
    
        let backCountryLabel = UILabel()
        backCountryLabel.text = country
        backCountryLabel.font = UIFont.systemFont(ofSize: 14)
        backCountryLabel.sizeToFit()
        let backCountryWidth =  backCountryLabel.bounds.size.width
        let backCountryHeight =  backCountryLabel.bounds.size.height
        backCountryLabel.textColor = textColorBack
        backCountryLabel.frame = CGRect(x: 0, y: -30, width: backCountryWidth, height: backCountryHeight)

        
        let backDateLabel = UILabel()
        backDateLabel.text = dateString
        backDateLabel.font = UIFont.systemFont(ofSize: 14)
        backDateLabel.sizeToFit()
        let backDateLabelWidth =  dateLabel.bounds.size.width
        let backDateLabelHeight =  dateLabel.bounds.size.height
        let backDateLabelXPosn = backCountryWidth + 6
        backDateLabel.textColor = UIColor(red:0.30, green:0.30, blue:0.30, alpha:0.45)
        backDateLabel.frame = CGRect(x: backDateLabelXPosn, y: CGFloat(-32.5), width: backDateLabelWidth, height: backDateLabelHeight)

        back.frame = CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight)
        back.backgroundColor = UIColor(white: 1.0, alpha:1.0)
        
        
        closeBack.addSubview(backCloseX)
        backLabel.addSubview(backCountryLabel)
        backLabel.addSubview(backDateLabel)
        back.addSubview(backLabel)
        back.addSubview(backText)
        back.addSubview(closeBack)

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostCard.someAction(sender:)))
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(PostCard.someAction(sender:)))
        let gestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(PostCard.closeCard(sender:)))
        let gestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(PostCard.closeCard(sender:)))

        self.front.isUserInteractionEnabled = true
        self.front.addGestureRecognizer(gestureRecognizer)
        self.back.addGestureRecognizer(gestureRecognizer2)
        closeFront.addGestureRecognizer(gestureRecognizer3)
        closeBack.addGestureRecognizer(gestureRecognizer4)

    }

    func flipToFrontOrBack() {
        if(frontShown) {
            insertSubview(front, at: 0)
        } else {
            insertSubview(back, at: 0)
        }
    }

    func someAction(sender:UITapGestureRecognizer){
        flipCard()
    }

    func closeCard(sender:UITapGestureRecognizer){
        let transitionOptions = UIViewAnimationOptions.transitionCrossDissolve
        self.frontShown = true

        UIView.transition(with: self, duration: 0.25, options: transitionOptions, animations: {
            self.removeFromSuperview()
        })
    }
    
    func flipCard() {
        let transitionOptions = UIViewAnimationOptions.transitionFlipFromRight
        
        UIView.transition(with: self, duration: 0.5, options: transitionOptions, animations: {
            if(self.frontShown) {
                self.front.removeFromSuperview()
                self.frontShown = false
                self.flipToFrontOrBack()
            } else {
                self.back.removeFromSuperview()
                self.frontShown = true
                self.flipToFrontOrBack()
            }
        })
    }
}
