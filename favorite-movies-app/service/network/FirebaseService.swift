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
        documentRef.setData(["title": movie.title, "year": movie.year, "imageUrl": movie.imageUrl, "plot": movie.plot]) {
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

    // TODO: find a way to delegate the viewcontroller to this class so we can update the mainTableView when we have the data from firebase.
//    func startMovieListener() {
//        moviesCollection.addSnapshotListener { (snapshot, error) in
//
//            self.movies.removeAll()
//
//            for document in snapshot!.documents {
//                if let title = document.data()["title"] as? String,
//                    let imageUrl = document.data()["imageUrl"] as? String,
//                    let year = document.data()["year"] as? String,
//                    let id = document.documentID as? String {
//                    let movie = Movie(id: id, title: title, year: year, imageUrl: imageUrl)
//                    self.movies.append(movie)
//                    print("received \(title)")
//                }
//            }
//            DispatchQueue.main.async {
//                self.viewController.mainTableView.reloadData()
//            }
//        }
//    }
}
