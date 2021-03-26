//
//  UserDataRepository.swift
//  KosmosAssignment
//
//  Created by Hitesh on 24/03/21.
//

import Foundation
import CoreData

struct UserDataRepository : BaseRepository {
    typealias T = User
    func create(_ record: User) -> Bool {
        let cdUser = CDUser(context: PersistentStorage.shared.context)
        cdUser.id = record.id != nil ? Int16(record.id!) : 0
        cdUser.email = record.email
        cdUser.firstName = record.firstName
        cdUser.lastName = record.lastName
        cdUser.avatar = record.avatar
        cdUser.isCreatedFromLocal = true
        PersistentStorage.shared.saveContext()
        return true
    }
    
    func getAll() -> [User]? {
        let records = PersistentStorage.shared.fetchManagedObject(managedObject: CDUser.self)
        guard records != nil && records?.count != 0 else {return nil}
        
        return records!.map{$0.convertToUser()}
    }
    
    func get(by email: String) -> User? {
        let result = getCDUser(by: email)
        guard result != nil else {return nil}
        return result!.convertToUser()
    }
    
    func update(_ record: User) -> Bool {
        let cdUser = self.getCDUser(by: record.email)
        guard cdUser != nil else {return false}
        cdUser?.firstName = record.firstName
        cdUser?.lastName = record.lastName
        cdUser?.avatar = record.avatar
        PersistentStorage.shared.saveContext()
        return true
    }
    
    func delete(by email: String) -> Bool {
        let cdUser = getCDUser(by: email)
        guard cdUser != nil else {return false}
        PersistentStorage.shared.context.delete(cdUser!)
        PersistentStorage.shared.saveContext()
        return true
    }
    
    private func getCDUser(by email:String) -> CDUser? {
        let fetchRequest:NSFetchRequest = CDUser.fetchRequest()
        let predicate = NSPredicate(format: "email==%@", email as CVarArg)
        fetchRequest.predicate = predicate
        let result = try! PersistentStorage.shared.context.fetch(fetchRequest)
        guard result.count != 0 else {return nil}

        return result.first
    }
    
}
