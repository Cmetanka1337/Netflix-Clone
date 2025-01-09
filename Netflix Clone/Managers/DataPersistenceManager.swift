//
//  DataPersistenceManager.swift
//  Netflix Clone
//
//  Created by Всеволод Буртик on 26.12.2024.
//

import Foundation
import UIKit
import CoreData

enum DatabaseError: Error{
    case failedToSave
    case failedToFetch
    case failedToDelete
}

class DataPersistenceManager {
    
    public static let shared = DataPersistenceManager()
    
    
    func downloadTitleWith(model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        item.id = Int64(model.id)
        item.adult = model.adult
        item.media_type = model.media_type
        item.original_title = model.original_title
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.title = model.title
        item.vote_average = model.vote_average
        item.vote_count = Int64(model.vote_count)
        
        do{
            try context.save()
            completion(.success(()))
        } catch {
                completion(.failure(DatabaseError.failedToSave))
        }
    }
    
    func fetchTitlesFromDatabase(completion: @escaping (Result<[TitleItem], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem> 
        
        request = TitleItem.fetchRequest()
                
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch {
            completion(.failure(DatabaseError.failedToFetch))
        }
    }
    
    func deleteTitleWith(model: TitleItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do{
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDelete))
        }
    }
}

