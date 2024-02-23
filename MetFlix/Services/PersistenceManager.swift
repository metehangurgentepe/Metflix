//
//  PersistenceManager.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 12.02.2024.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}


enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func isSaved(favorite: Movie, completion: @escaping (Result<Bool,MovieError>) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                guard !favorites.contains(favorite) else {
                    print("here")
                    completion(.success(true))
                    return
                }
                completion(.success(false))
            case .failure(let failure):
                completion(.failure(.serializationError))
            }
        }
    }
    
    
    static func updateWith(favorite: Movie, actionType: PersistenceActionType, completion: @escaping (MovieError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
                
                switch actionType {
                case .add:
                    guard !favorites.contains(favorite) else {
                        completion(.unableToFavorite)
                        return
                    }
                    
                    favorites.append(favorite)
                case .remove:
                    favorites.removeAll { $0.id == favorite.id }
                }
                
               completion(save(favorites: favorites))
                
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    
    static func retrieveFavorites(completion: @escaping (Result<[Movie],MovieError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Movie].self, from: favoritesData)
            completion(.success(favorites))
        } catch {
            completion(.failure(.unableToFavorite))
        }
    }
    
    
    static func save(favorites: [Movie]) -> MovieError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.setValue(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}
