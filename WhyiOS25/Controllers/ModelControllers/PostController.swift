//
//  Postcontroller.swift
//  WhyiOS25
//
//  Created by Carson Buckley on 3/21/19.
//  Copyright © 2019 Launch. All rights reserved.
//

import Foundation

class PostController {
    
    static let baseUrl = URL(string: "https://whydidyouchooseios.firebaseio.com/reasons")
    
    static func fetchPosts(completion: @escaping ([Post]?) -> Void) {
        guard let unwrappedUrl = baseUrl else { completion(nil) ; return }
        
        let getterEndpoint = unwrappedUrl.appendingPathComponent(".json")
        
        var request = URLRequest(url: getterEndpoint)
        
        request.httpBody = nil
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error)
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data found from fetch posts")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedDictionary = try decoder.decode([String: Post].self, from: data)
                let decodedPosts = decodedDictionary.compactMap( { $0.value })
                completion(decodedPosts)
                
            } catch {
                print(error)
                completion(nil)
                return
            }
        }.resume()
    }
    
    static func postReason(name: String, cohort: String, reason: String, completion: @escaping (Bool) -> Void) {
        guard var unwrappedUrl = baseUrl else { completion(false) ; return }
        unwrappedUrl.appendPathComponent(".json")
        let newPost = Post(name:name, cohort: cohort, reason: reason)
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(newPost)
            var request = URLRequest(url: unwrappedUrl)
            request.httpMethod = "POST"
            request.httpBody = data
            
            URLSession.shared.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    print("Error POSTing to API: \(error)")
                    completion(false)
                    return
                }
                if data != nil {
                    completion(true)
                    return
                }
                completion(false)
            }.resume()
        } catch {
            print("Error encoding post: \(error)")
            completion(false)
            return
        }
    }
}

