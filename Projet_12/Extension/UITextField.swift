//
//  UITextField.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 05/05/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

extension UITextField {

    /**
     Function that checks if the text in the textfield is valid and returns the text.

     Calling this function checks if the textfield text exists,
     and changes the appearance of the textfield in red and returns nil if it is false
     or restores the appearance (text gray) of the textfield and returns the text if it is true.
 
     - Parameter placeholder: The text to display in the placeholder.
     - Returns: The text in the textfield.
     */
    func checkTextfield(placeholder: String) -> String? {
        guard let text = self.text, text != "", text != " " else {
            setAlertTextField(placeholder: placeholder)
            return nil
        }
        restore(placeholder: placeholder)
        return text
    }

    /// Function that sets the placeholder text red and adds a red border to the textfield.
    private func setAlertTextField(placeholder: String) {
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                        attributes: [NSAttributedString.Key.foregroundColor:
                                                            UIColor.red])
    }

    /// Function that restores the textfield (removes the border and sets the placeholder text gray).
    func restore(placeholder: String) {
        self.layer.borderWidth = 0
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                        attributes: [NSAttributedString.Key.foregroundColor:
                                                            UIColor.placeholderGray])
    }
}
