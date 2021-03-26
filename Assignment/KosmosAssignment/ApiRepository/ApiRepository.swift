//
//  ApiRepository.swift
//  KosmosAssignment
//
//  Created by Hitesh on 24/03/21.
//

import Foundation

let dataErrorDomain = "dataErrorDomain"
let baseURL = "https://reqres.in/api/"

enum DataErrorCode: NSInteger {
    case networkUnavailable = 101
    case wrongDataFormat = 102
}

final class ApiRepository {
    static let shared = ApiRepository()
    private init() {}
    
    private let urlSession = URLSession.shared
    
    func getUsers(nextPage:Int,completion:@escaping(_ data:UserData?, _ error:Error?) -> Void) {
        
        guard let userListURL = URL(string: baseURL + "users?page=\(nextPage)") else {
            completion(nil, nil)
            return
        }
        urlSession.dataTask(with: userListURL) { (data, response, error) in
            if let error = error {
                completion(nil, error)
            }
            
            guard let data = data else {
                let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
                completion(nil, error)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(UserData.self, from: data)
                completion(result, nil)
            } catch {
                completion(nil, error)
            }
        }
        .resume()
    }
    
}
