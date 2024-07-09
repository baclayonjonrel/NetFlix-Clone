//
//  DataPersistenceManager.swift
//  NetFlix Clone
//
//  Created by Jonrel Baclayon on 7/8/24.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    
    enum DatabaseError: Error {
        case FailedToSaveData
        case FailedToFetchData
        case FailedToDeleteData
    }
    
    static let shared = DataPersistenceManager()
    
    func downloadMovieWith(model: Media, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = MovieItem(context: context)
        item.original_title     = model.original_title
        item.original_name      = model.original_name
        item.overview           = model.overview
        item.id                 = Int64(model.id)
        item.media_type         = model.media_type
        item.name               = model.name
        item.poster_path        = model.poster_path
        item.release_date       = model.release_date
        item.vote_average       = model.vote_average
        item.vote_count         = Int64(model.vote_count)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.FailedToSaveData))
        }
    }
    
    func fetchMovieFromDatabase(completion: @escaping (Result<[MovieItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<MovieItem>
        
        request = MovieItem.fetchRequest()
        
        do {
            let movies = try context.fetch(request)
            completion(.success(movies))
        } catch {
            completion(.failure(DatabaseError.FailedToFetchData))
        }
    }
    
    func deleteMovieOnDatabase(model: MovieItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.FailedToDeleteData))
        }
    }
    
    func isMovieSaved(id: Int64) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<MovieItem> = MovieItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            print("Failed to fetch movie: \(error)")
            return false
        }
    }
}
