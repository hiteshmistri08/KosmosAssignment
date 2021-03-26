//
//  CDUser+Extension.swift
//  KosmosAssignment
//
//  Created by Hitesh on 24/03/21.
//

import Foundation

extension CDUser {
    func update(user:User) {
        self.avatar = user.avatar
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.id = Int16(user.id ?? 0)
        self.email = user.email
    }
    func convertToUser() -> User {
        let user = User(id: Int(self.id), email: self.email ?? "", firstName: self.firstName ?? "", lastName: self.lastName, avatar: self.avatar)
        return user
    }
}
