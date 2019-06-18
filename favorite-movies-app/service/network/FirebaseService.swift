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

    let viewController = ViewController()

    func uploadMovieToDB(movie: Movie, documentRef: DocumentReference) {
        documentRef.setData(["title": movie.title, "year": movie.year, "imageUrl": movie.imageUrl]) {
            error in
            if error != nil {
                print("Error adding movie to DB")
            } else {
                print("Success in adding movie to DB")
            }
        }
    }

    func deleteMovieFromDB(movieId: String) {
        moviesCollection.document(movieId).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}
