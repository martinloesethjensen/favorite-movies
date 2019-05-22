//
//  Movie.swift
//  favorite-movies-app
//
//  Created by Martin Løseth Jensen on 13/05/2019.
//  Copyright © 2019 Martin Løseth Jensen. All rights reserved.
//

import Foundation

class Movie {
    var id: String = ""
    var title: String = ""
    var year: String = ""
    var imageUrl: String = ""
    
    init(id: String, title: String, year: String, imageUrl: String) {
        self.id = id
        self.title = title
        self.year = year
        self.imageUrl = imageUrl
    }
}
