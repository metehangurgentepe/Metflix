//
//  CoreDataManager.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 9.10.2024.
//
import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NetflixClone")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext(){
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - UserList Operations
    
    func addToUserList(username: String, imageName: String) -> User? {
        let userList = User(context: context)
        userList.userID = UUID()
        userList.username = username
        userList.dateAdded = Date()
        userList.imageName = imageName
        
        print("Generated UUID: \(UUID())")
        print("Current Date: \(Date())")

        
        saveContext()
        return userList
    }
    
    func fetchUserList(for userId: String) throws -> [User] {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", userId as CVarArg)
        
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
    
    // MARK: - MyList Operations
    func addMyList(userId: String, movieId: Int) -> MyList? {
        let myList = MyList(context: context)
        myList.userId = userId
        myList.movieId = Int64(movieId)
        
        saveContext()
        return myList
    }
    
    func removeMyList(userId: String, movieId: Int) throws {
        let request: NSFetchRequest<MyList> = MyList.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@ AND movieId == %@", userId as CVarArg, NSNumber(value: movieId))
        
        do {
            let results = try context.fetch(request)
            for myList in results {
                context.delete(myList)
            }
            saveContext()
        } catch {
            print("Error removing MyList: \(error)")
            throw MovieError.invalidResponse
        }
    }
    
    func isMovieInMyList(userId: String, movieId: Int) throws -> Bool {
        let request: NSFetchRequest<MyList> = MyList.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@ AND movieId == %d", userId, Int64(movieId))
        
        do {
            let results = try context.fetch(request)
            return !results.isEmpty
        } catch {
            print("Error fetching MyList: \(error)")
            throw MovieError.invalidResponse
        }
    }
    
    func fetchMyList(userId: String) -> [MyList]{
        let request: NSFetchRequest<MyList> = MyList.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", userId as CVarArg)
        
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
    
    
    // MARK: - LikedMovie Operations
    
    func isMovieInLike(userId: String, movieId: Int) throws -> Bool {
        let request: NSFetchRequest<LikedMovie> = LikedMovie.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@ AND movieId == %d", userId, Int64(movieId))
        
        do {
            let results = try context.fetch(request)
            return !results.isEmpty
        } catch {
            print("Error fetching MyList: \(error)")
            throw MovieError.invalidResponse
        }
    }
    
    func likeMovie(userId: String, movieId: Int) -> LikedMovie? {
        let likedMovie = LikedMovie(context: context)
        likedMovie.userId = userId
        likedMovie.movieId = Int64(movieId)
        likedMovie.likedDate = Date()
        
        saveContext()
        return likedMovie
    }
    
    func removeLikedMovie(userId: String, movieId: Int) throws{
        let request: NSFetchRequest<LikedMovie> = LikedMovie.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@ AND movieId == %d", userId, Int64(movieId))

        do {
            let results = try context.fetch(request)
            for likedMovie in results {
                context.delete(likedMovie)
            }
            saveContext()
        } catch {
            throw MovieError.invalidResponse
        }
    }
    
    func fetchLikedMovies(userId: String) -> [LikedMovie]{
        let request: NSFetchRequest<LikedMovie> = LikedMovie.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", userId as CVarArg)
        
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
    
    // MARK: - DownloadedMovie Operations
    
    func downloadMovie(userId: String, movieId: Int) -> DownloadedMovie? {
        let downloadedMovie = DownloadedMovie(context: context)
        downloadedMovie.userId = userId
        downloadedMovie.movieId = Int32(movieId)
        downloadedMovie.downloadDate = Date()
        let oneMonthLater = Calendar.current.date(byAdding: .month, value: 1, to: Date())
        downloadedMovie.expirationDate = oneMonthLater
        
        saveContext()
        return downloadedMovie
    }
    
    func removeDownloadedMovie(userId: String, movieId: Int) throws{
        let request: NSFetchRequest<DownloadedMovie> = DownloadedMovie.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@ AND movieId == %@", userId as CVarArg, movieId as CVarArg)
        
        do {
            let results = try context.fetch(request)
            for downloadedMovie in results {
                context.delete(downloadedMovie)
            }
            saveContext()
        } catch {
            throw MovieError.invalidResponse
        }
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
    
    func removeDislikedMovie(userId: String, movieId: Int) throws {
        let request: NSFetchRequest<DislikedMovie> = DislikedMovie.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@ AND movieId == %@", userId as CVarArg, movieId as CVarArg)
        
        do {
            let results = try context.fetch(request)
            for dislikedMovie in results {
                context.delete(dislikedMovie)
            }
            saveContext()
        } catch {
            throw MovieError.invalidResponse
        }
    }
    
    func fetchDislikedMovies(for userId: String) -> [DislikedMovie] {
        let request: NSFetchRequest<DislikedMovie> = DislikedMovie.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", userId as CVarArg)
        
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
    
    func isMovieInDislike(userId: String, movieId: Int) throws -> Bool {
        let request: NSFetchRequest<DislikedMovie> = DislikedMovie.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@ AND movieId == %d", userId, Int64(movieId))
        
        do {
            let results = try context.fetch(request)
            return !results.isEmpty
        } catch {
            print("Error fetching MyList: \(error)")
            throw MovieError.invalidResponse
        }
    }
}
