//
//  FavoriteTopicInfos.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 31/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation

// The informations of a favorite topic.
class FavoriteTopicInfos {

    /// The id of the serie that the favorite topic is about.
    let serieId: Int

    /// The id of the favorite topic.
    var topicId: String

    /**
     Initializes a new topic on a serie with some informations.
     
     - Parameters:
        - serieId: The id of the serie that the favorite topic is about.
        - topicId: The id of the favorite topic.
     */
    init(serieId: Int, topicId: String) {
        self.serieId = serieId
        self.topicId = topicId
    }
}
