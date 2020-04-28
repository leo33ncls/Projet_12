//
//  Print.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 28/04/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation

// Writes the textual representations of the given items into the standard output if it's a debug build.
func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    Swift.print(items[0], separator: separator, terminator: terminator)
    #endif
}
