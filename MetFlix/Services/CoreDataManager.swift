//
//  CoreDataManager.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 9.10.2024.
//

import CoreData
import Foundation

protocol CoreDataManagerProtocol {
    func fetchLikedMovies(userId: String) -> [LikedMovie]
    func fetchMyList(userId: String) -> [MyList]
    func isMovieInMyList(userId: String, movieId: Int) -> Bool
    func addToMyList(userId: String, movieId: Int) -> MyList?
    func removeFromMyList(userId: String, movieId: Int) throws
    func likeMovie(userId: String, movieId: Int) -> LikedMovie?
    func unlikeMovie(userId: String, movieId: Int) throws
    func isMovieLiked(userId: String, movieId: Int) -> Bool
    func dislikeMovie(userId: String, movieId: Int) -> DislikedMovie?
    func removeDislike(userId: String, movieId: Int) throws
    func isMovieDisliked(userId: String, movieId: Int) -> Bool
}

class CoreDataManager: CoreDataManagerProtocol {
    static let shared = CoreDataManager()
    
    private init() {}
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NetflixClone")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - User Operations
    
    func addUser(username: String, imageName: String) -> User? {
        let user = User(context: context)
        user.userId = UUID()
        user.username = username
        user.dateAdded = Date()
        user.imageName = imageName
        
        saveContext()
        return user
    }
    
    func fetchUsers(for userId: String) -> [User] {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", userId as CVarArg)
        
        return (try? context.fetch(request)) ?? []
    }
    
    func fetchUser(for userId: String) -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", userId as CVarArg)
        
        do {
            let results = try context.fetch(request)
            return results.first
        } catch {
            return nil
        }
    }
    
    // MARK: - MyList Operations
    
    func addToMyList(userId: String, movieId: Int) -> MyList? {
        let myList = MyList(context: context)
        myList.userId = userId
        myList.movieId = Int64(movieId)
        
        saveContext()
        return myList
    }
    
    func removeFromMyList(userId: String, movieId: Int) throws {
        let request: NSFetchRequest<MyList> = MyList.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@ AND movieId == %d", userId, Int64(movieId))
        
        let results = try context.fetch(request)
        results.forEach { context.delete($0) }
        saveContext()
    }
    
    func isMovieInMyList(userId: String, movieId: Int) -> Bool {
        let request: NSFetchRequest<MyList> = MyList.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@ AND movieId == %d", userId, Int64(movieId))
        
        return (try? context.count(for: request)) ?? 0 > 0
    }
    
    func fetchMyList(userId: String) -> [MyList] {
        let request: NSFetchRequest<MyList> = MyList.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", userId as CVarArg)
        
        return (try? context.fetch(request)) ?? []
    }
    
    // MARK: - LikedMovie Operations
    
    func isMovieLiked(userId: String, movieId: Int) -> Bool {
        let request: NSFetchRequest<LikedMovie> = LikedMovie.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@ AND movieId == %d", userId, Int64(movieId))
        
        return (try? context.count(for: request)) ?? 0 > 0
    }
    
    func likeMovie(userId: String, movieId: Int) -> LikedMovie? {
        let likedMovie = LikedMovie(context: context)
        likedMovie.userId = userId
        likedMovie.movieId = Int64(movieId)
        likedMovie.likedDate = Date()
        
        saveContext()
        return likedMovie
    }
    
    func unlikeMovie(userId: String, movieId: Int) throws {
        let request: NSFetchRequest<LikedMovie> = LikedMovie.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@ AND movieId == %d", userId, Int64(movieId))

        let results = try context.fetch(request)
        results.forEach { context.delete($0) }
        saveContext()
    }
    
    func fetchLikedMovies(userId: String) -> [LikedMovie] {
        let request: NSFetchRequest<LikedMovie> = LikedMovie.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", userId as CVarArg)
        
        return (try? context.fetch(request)) ?? []
    }
    
    // MARK: - DownloadedMovie Operations
    
    func downloadMovie(userId: String, movieId: Int) -> DownloadedMovie? {
        let downloadedMovie = DownloadedMovie(context: context)
        downloadedMovie.userId = userId
        downloadedMovie.movieId = Int32(movieId)
        downloadedMovie.downloadDate = Date()
        downloadedMovie.expirationDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())
        
        saveContext()
        return downloadedMovie
    }
    
    func removeDownloadedMovie(userId: String, movieId: Int) throws {
        let request: NSFetchRequest<DownloadedMovie> = DownloadedMovie.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@ AND movieId == %d", userId, Int32(movieId))
        
        let results = try context.fetch(request)
        results.forEach { context.delete($0) }
        saveContext()
    }
    
    // MARK: - DislikedMovie Operations
    
    func dislikeMovie(userId: String, movieId: Int) -> DislikedMovie? {
        let dislikedMovie = DislikedMovie(context: context)
        dislikedMovie.userId = userId
        dislikedMovie.movieId = Int32(movieId)
        dislikedMovie.dislikedDate = Date()
        
        saveContext()
        return dislikedMovie
    }
    
    func removeDislike(userId: String, movieId: Int) throws {
        let request: NSFetchRequest<DislikedMovie> = DislikedMovie.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@ AND movieId == %d", userId, Int32(movieId))
        
        let results = try context.fetch(request)
        results.forEach { context.delete($0) }
        saveContext()
    }
    
    func fetchDislikedMovies(for userId: String) -> [DislikedMovie] {
        let request: NSFetchRequest<DislikedMovie> = DislikedMovie.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", userId as CVarArg)
        
        return (try? context.fetch(request)) ?? []
    }
    
    func isMovieDisliked(userId: String, movieId: Int) -> Bool {
        let request: NSFetchRequest<DislikedMovie> = DislikedMovie.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@ AND movieId == %d", userId, Int32(movieId))
        
        return (try? context.count(for: request)) ?? 0 > 0
    }
}
