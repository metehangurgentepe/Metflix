//
//  SelectProfileViewModel.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 9.10.2024.
//

import Foundation
import CoreData

class SelectProfileViewModel: SelectProfileViewModelProtocol {
    var users: [User] = []
    
    var delegate: SelectProfileViewModelDelegate?
    
    let context = CoreDataManager.shared.persistentContainer.viewContext
    
    func createUser(name: String, imageName: String) {
        let newUser = User(context: context)
        newUser.username = name
        newUser.imageName = imageName
        
        saveContext()
    }
    
    func fetchUsers() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            users = try context.fetch(fetchRequest)
            self.delegate?.handleOutput(.fetchUsers(users))
        } catch {
            self.delegate?.handleOutput(.error(error as! MovieError))
        }
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            self.delegate?.handleOutput(.error(error as! MovieError))
        }
    }
    
    func deleteUser(_ user: User) {
        context.delete(user)
        saveContext()
    }
}
