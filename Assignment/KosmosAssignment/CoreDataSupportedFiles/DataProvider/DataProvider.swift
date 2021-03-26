//
//  DataProvider.swift
//  KosmosAssignment
//
//  Created by Hitesh on 25/03/21.
//

import Foundation
import CoreData

class DataProvider {
    private let persistanceContainer:NSPersistentContainer
    private let repository: ApiRepository
    
    init(persistanceContainer:NSPersistentContainer, repository:ApiRepository) {
        self.persistanceContainer = persistanceContainer
        self.repository = repository
    }
    
    func fetchUsers(nextPage:Int, completion:@escaping(UserPageData?,Error?) -> Void) {
        let taskContext = persistanceContainer.viewContext
        repository.getUsers(nextPage: nextPage) { [weak self] (userData, error) in
            if let error = error {
                completion(nil,error)
                return
            }
            
            guard let data = userData else {
                let error = NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
                completion(nil, error)
                return
            }
            
//            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//            taskContext.undoManager = nil
            
            _ = self?.syncUsers(userData:data.data,taskContext:taskContext)
            
            completion(UserPageData(page: data.page, perPage: data.perPage, total: data.total, totalPages: data.totalPages), nil)
        }
    }
    
    func syncUsers(userData:[User],taskContext:NSManagedObjectContext) -> Bool {
        var successfull = false
        taskContext.performAndWait {
            let cdUserRequest:NSFetchRequest<NSFetchRequestResult> = CDUser.fetchRequest()
            let userEmails = userData.map{$0.email}
            cdUserRequest.predicate = NSPredicate(format: "email in %@", [userEmails])
            
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: cdUserRequest)
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            do {
                let batchResults = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
                if let deletedObjectIds = batchResults?.result as? [NSManagedObject] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey : deletedObjectIds], into: [self.persistanceContainer.viewContext])
                }
            } catch {
                print("Error: \(error)\nCould not batch delete existing records.")
                return
            }
            
            // Create new records.
            for user in userData {
                guard let cdUser = NSEntityDescription.insertNewObject(forEntityName: "CDUser", into: taskContext) as? CDUser else {
                    print("Error: Failed to create a new CDUser object!")
                    return
                }
                cdUser.update(user: user)
            }
            
            //Save All changes
            if taskContext.hasChanges {
                do {
                    try taskContext.save()
                } catch {
                    print("Error: \(error)\nCould not save Core Data context.")
                }
                taskContext.reset() // Reset the context to clean up the cache and low the memory footprint.
            }
            successfull = true
        }
        return successfull
    }
    
}
