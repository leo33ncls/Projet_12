//
//  CustomShadowLayer.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 02/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

// Class that creates a custom shadow for a view
class CustomShadowLayer: CAGradientLayer {

    /**
     Initializes a custom shadow for a view.
     
     - Parameters:
     - view: The view on which we want to add the custom shadow.
     - shadowColor: The color of the custom shadow.
     - shadowWidth: The width of the custom shadow.
     - shadowRadius: The radius of the custom shadow.
     */
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
