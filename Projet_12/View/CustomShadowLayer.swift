//
//  CustomShadowLayer.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 02/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

class CustomShadowLayer: CAGradientLayer {
    init(view: UIView, shadowColor: UIColor, shadowWidth: CGFloat, shadowRadius: CGFloat) {
        super.init()
        self.colors = [shadowColor.cgColor, UIColor.clear.cgColor]
        self.shadowRadius = shadowRadius
        let viewFrame = view.frame
        
        startPoint = CGPoint(x: 0.5, y: 1.0)
        endPoint = CGPoint(x: 0.5, y: 0.0)
        self.frame = CGRect(x: 0.0, y: viewFrame.height - shadowRadius, width: shadowWidth, height: shadowRadius)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
