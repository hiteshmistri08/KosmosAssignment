//
//  CDUser+CoreDataProperties.swift
//  KosmosAssignment
//
//  Created by Hitesh on 24/03/21.
//
//

import Foundation
import CoreData


extension CDUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged public var id: Int16
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var avatar: String?
    @NSManaged public var isCreatedFromLocal: Bool

}

extension CDUser : Identifiable {

}
