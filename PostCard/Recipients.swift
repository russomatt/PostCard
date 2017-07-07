//
//  Recipients.swift
//  PostCard
//
//  Created by Matthew Russo on 7/5/17.
//  Copyright © 2017 Olya Danylova. All rights reserved.
//

import UIKit
class Recipients: UIView {
    var name: String
    
    init(frame: CGRect, name: String) {
        self.name = name
        super.init(frame: frame)

        drawRecipient()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawRecipient() {
        let viewframe = self.frame
        let userPicture = UIView(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
        let label = UILabel(frame: CGRect(x: 65, y: 10, width: (viewframe.width - 65), height: 40))

        label.text = self.name
        userPicture.backgroundColor = UIColor.red
        
        self.layer.borderColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.05).cgColor
        self.layer.borderWidth = 1.0
        self.backgroundColor = UIColor.white
        self.addSubview(label)
        self.addSubview(userPicture)
    }
    
}
