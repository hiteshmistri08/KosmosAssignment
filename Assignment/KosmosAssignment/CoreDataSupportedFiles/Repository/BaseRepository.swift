//
//  BaseRepository.swift
//  KosmosAssignment
//
//  Created by Hitesh on 24/03/21.
//

import Foundation

protocol BaseRepository {
    associatedtype T
    func create(_ record:T) -> Bool
    func getAll() -> [T]?
    func get(by email:String) -> T?
    func update(_ record:T) -> Bool
    func delete(by email:String) -> Bool
}
