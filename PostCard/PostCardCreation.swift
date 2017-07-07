//
//  PostCard.swift
//  PostCard
//
//  Created by Matthew Russo on 6/20/17.
//  Copyright © 2017 Olya Danylova. All rights reserved.
//

import UIKit

@IBDesignable class CreatePostCard: UIView {
    let APPLICATION_ID = "63E6BEB9-AC2E-0B24-FF2C-F948484DAB00"
    let API_KEY = "2C160E48-1E10-FDA0-FF44-EB006605BF00"
    let REST_KEY = "EF808C18-6125-4C6F-FFEA-72F6D8807800"
    let SERVER_URL = "https://api.backendless.com"
    let backendless = Backendless.sharedInstance()!
    var id: String?
    var country: String?
    var dateString: String?
    var city: String?
    var image: UIImage?
    var front = UIImageView()
    var back = UIView()
    var frontShown = true
    let sendFrame = UIView()
    var latitude: Double?
    var longitude: Double?
    var backText =  UITextView()

    init(frame: CGRect,id: String, country: String, city: String, dateString: String, image: UIImage,latitude: Double, longitude: Double) {
        self.id = id
        self.country = country
        self.city = city
        self.dateString = dateString
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
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
        
        // Front Set Up
        front.frame = CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight)
        front.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        front.image = image

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
        
        let instructionsText = "     Tap to flip"
        let instructions = UILabel()
        instructions.text = instructionsText
        instructions.frame = CGRect(x: 0, y: -150, width: widthWithMargins, height: 70)
        instructions.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        instructions.textColor = UIColor.white
        instructions.isUserInteractionEnabled = false
        
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
        label.addSubview(instructions)
        front.addSubview(label)
        
        // Back Set Up
        
        let backLabel = UILabel()
        backLabel.text = city
        backLabel.adjustsFontSizeToFitWidth = true
        backLabel.frame = CGRect(x: 20, y: 90, width: widthWithMargins, height: 42)
        backLabel.textColor = textColorBack
        backLabel.font = UIFont.boldSystemFont(ofSize: 42)
        
        let backTextLabel = UILabel()
        backTextLabel.text = "Type your message below"
        backTextLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.4)
        backTextLabel.sizeToFit()
        backTextLabel.frame = CGRect(x: 0, y: 45, width: backTextLabel.frame.width, height: backTextLabel.frame.height)
        backTextLabel.font = UIFont.systemFont(ofSize: 16)

        backText.frame = CGRect(x: 20, y: 160, width: widthWithMargins, height: 400)
        backText.textColor = textColorBack
        backText.isUserInteractionEnabled = true
        backText.font = UIFont.systemFont(ofSize: 16)
        
        backText.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.25).cgColor
        backText.layer.borderWidth = 1.0
        backText.layer.cornerRadius = 3.0
        backText.addSubview(backTextLabel)
        
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
        
        let cancelButton = UIButton()
        let sendButton = UIButton()
        
        cancelButton.setTitle("CANCEL", for: .normal)
        sendButton.setTitle("SEND", for: .normal)
        cancelButton.setTitleColor(UIColor.red, for: .normal)
        sendButton.setTitleColor(UIColor.red, for: .normal)

        cancelButton.sizeToFit()
        sendButton.sizeToFit()
        
        let w1 = cancelButton.bounds.size.width + 40
        
        cancelButton.frame = CGRect(x: 0, y: (cardHeight - 60), width: w1, height: 50)
        sendButton.frame = CGRect(x: (cardWidth - w1), y: (cardHeight - 60), width: w1, height: 50)
        
        backLabel.addSubview(backTextLabel)
        backLabel.addSubview(backCountryLabel)
        backLabel.addSubview(backDateLabel)
        back.addSubview(backLabel)
        back.addSubview(backText)
        back.addSubview(cancelButton)
        back.addSubview(sendButton)

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreatePostCard.someAction(sender:)))
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(CreatePostCard.someAction(sender:)))
        let gestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(cancelCard(sender:)))
        let gestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(sendCard(sender:)))
        
        self.front.isUserInteractionEnabled = true
        self.front.addGestureRecognizer(gestureRecognizer)
        self.back.addGestureRecognizer(gestureRecognizer2)
        cancelButton.addGestureRecognizer(gestureRecognizer3)
        sendButton.addGestureRecognizer(gestureRecognizer4)
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
    
    func cancelCard(sender:UITapGestureRecognizer) {
        self.removeFromSuperview()
    }

    func sendCard(sender:UITapGestureRecognizer) {
        showDialog()
    }
    
    func showDialog() {
        let width = self.frame.size.width
        let height = self.frame.size.height
        sendFrame.frame = CGRect(x: 0, y:0, width: width, height: height)
        sendFrame.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.75)
        
        let recipientDialog = UIView(frame: CGRect(x: 0, y: 0, width: (width - 40.0), height: (height / 2.25)))
        recipientDialog.backgroundColor = UIColor.white
        recipientDialog.center = CGPoint(x: (width / 2), y: (height / 2.25))
        
        let dialogWidth = recipientDialog.frame.size.width
        let dialogHeight = recipientDialog.frame.size.height
        
        let backButton = UIButton()
        let sendButton = UIButton()
        
        backButton.setTitle("BACK", for: .normal)
        sendButton.setTitle("SEND", for: .normal)
        backButton.setTitleColor(UIColor.red, for: .normal)
        sendButton.setTitleColor(UIColor.red, for: .normal)
        
        backButton.sizeToFit()
        sendButton.sizeToFit()
        
        let w1 = backButton.bounds.size.width + 40
        
        backButton.frame = CGRect(x: 20, y: (dialogHeight + 90), width: w1, height: 50)
        sendButton.frame = CGRect(x: (dialogWidth - w1 + 20), y: (dialogHeight + 90), width: w1, height: 50)
        
        let recipient = Recipients(frame: CGRect(x: 0.0, y: 0.0, width: recipientDialog.frame.width, height: 60.0), name: "Carisa")
        let recipient2 = Recipients(frame: CGRect(x: 0.0, y: 60.0, width: recipientDialog.frame.width, height: 60.0), name: "Nicolai")
        let recipient3 = Recipients(frame: CGRect(x: 0.0, y: 120.0, width: recipientDialog.frame.width, height: 60.0), name: "Lee")
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeDialog(sender:)))
        let gestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(selectRecipient(sender:)))
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(selectRecipient(sender:)))
        let gestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(selectRecipient(sender:)))
        let gestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(sendCardToRecipients(sender:)))

        backButton.addGestureRecognizer(gestureRecognizer)
        sendButton.addGestureRecognizer(gestureRecognizer4)
        recipient.addGestureRecognizer(gestureRecognizer1)
        recipient2.addGestureRecognizer(gestureRecognizer2)
        recipient3.addGestureRecognizer(gestureRecognizer3)
        self.addSubview(sendFrame)
        sendFrame.addSubview(recipientDialog)
        sendFrame.addSubview(backButton)
        sendFrame.addSubview(sendButton)
        recipientDialog.addSubview(recipient)
        recipientDialog.addSubview(recipient2)
        recipientDialog.addSubview(recipient3)

    }
    func selectRecipient(sender:UITapGestureRecognizer) {
        if( sender.view?.backgroundColor == UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 0.1)) {
            sender.view?.backgroundColor = UIColor.white
        } else {
            sender.view?.backgroundColor = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 0.1)
        }
    }

    func closeDialog(sender:UITapGestureRecognizer) {
        sendFrame.removeFromSuperview()
    }

    class PostCardData: NSObject {
        
        var CardID: String
        var Country: String
        var City: String
        var DateString: String
        var Text: String
        var Latitude: Double
        var Longitude: Double
        
        init(CardID: String, Country: String, City: String, DateString: String, Text: String, Latitude: Double, Longitude: Double) {
            self.CardID = CardID
            self.Country = Country
            self.City = City
            self.DateString = DateString
            self.Text = Text
            self.Latitude = Latitude
            self.Longitude = Longitude
        }
        
    }

    func sendCardToRecipients(sender:UITapGestureRecognizer) {
        let text = backText.text
        let dataStore2 = self.backendless.data.ofTable("SentPostCards")
        let test = PostCardData(CardID: id!, Country: country!, City: city!, DateString: dateString!, Text: text!, Latitude: latitude!, Longitude: longitude!)
        let data = UIImageJPEGRepresentation(image!, 0.5)
        let idString = id!
        var error: Fault?
        if error == nil {
            print("No Error!")
        } else {
            print("Server reported an error: \(String(describing: error))")
        }
        dataStore2?.save(
            test,
            response: { (result: Any!) -> Void in
                print("Post card data saved")
        },
            error:  { (fault: Fault!) -> Void in
                print("Server reported an error: \(fault)")}
        )

        self.backendless.fileService.saveFile(
            "media/\(idString).JPG",
            content: data,
            response: { ( uploadedFile : BackendlessFile!) -> () in
                print("File has been uploaded. File URL is - \(uploadedFile.fileURL)")
        },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
        })

        self.removeFromSuperview()
    }
}
