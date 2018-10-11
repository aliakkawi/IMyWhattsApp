//
//  RoundedImage.swift
//  IMyWhattsApp
//
//  Created by Ali Akkawi on 07/10/2018.
//  Copyright © 2018 Ali Akkawi. All rights reserved.
//

import Foundation
import UIKit
class Roundedimage: UIImageView {
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
