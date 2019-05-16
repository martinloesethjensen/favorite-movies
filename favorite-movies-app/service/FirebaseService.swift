//
//  FirebaseService.swift
//  favorite-movies-app
//
//  Created by Martin Løseth Jensen on 16/05/2019.
//  Copyright © 2019 Martin Løseth Jensen. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseService {
    
    // Database
    let moviesCollection = Firestore.firestore().collection("movies")
    
    // Storage
    let storage = Storage.storage() // service
    var storageRef: StorageReference?
    
    var movies = [Movie]()
    
    func uploadMovieToDB(movie:Movie, documentRef:DocumentReference) {
        documentRef.setData(["title":movie.title, "year":movie.year, "imageUrl":movie.imageUrl, "plot":movie.plot]) {
            error in
            if error != nil {
                print("Error adding movie to DB")
            }else {
                print("Success in adding movie to DB")
            }
        }
    }
}
