//
//  RepresentativeController.swift
//  Representative-master
//
//  Created by Eric Lanza on 1/16/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

class RepresentativeController {
    
    static let baseURL = URL(string: "http://whoismyrepresentative.com/getall_reps_bystate.php")
    
    // Black Diamond: Search for rep by last name NEW URL
    static let baseURLForNameSearch = URL(string: "https://whoismyrepresentative.com/getall_reps_byname.php")
    
    static func searchRepresentatives(forState state: String, completion: @escaping (([Representative]) -> Void)) {
        guard let url = baseURL else { completion([]); return }
        
        let stateQuery = URLQueryItem(name: "state", value: state.lowercased())
        let jsonQuery = URLQueryItem(name: "output", value: "json")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [stateQuery, jsonQuery]
        guard let requestURL = components?.url else { completion([]); return }
        
        let dataTask = URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("Error getting representatives: \(error.localizedDescription)")
                completion([])
                return
            }
            guard let data = data,
                let responseDataString = String(data: data, encoding: .ascii),
                let fixedData = responseDataString.data(using: .utf8)
                else { completion([]); return }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let resultsDictionary = try jsonDecoder.decode([String: [Representative]].self, from: fixedData)
                let repArray = resultsDictionary["results"]
                completion(repArray ?? [])
            } catch {
                print("Error decoding json: \(error.localizedDescription)")
            }
        }
        dataTask.resume()
    }
    
    // Black Diamond: Search for rep by last name (second option)
    static func searchforRepresentativeBy(lastName: String, completion: @escaping ([Representative]) -> Void) {
        guard let url = baseURLForNameSearch else { completion([]); return }
        
        let nameQuery = URLQueryItem(name: "name", value: lastName.lowercased())
        let jsonQuery = URLQueryItem(name: "output", value: "json")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [nameQuery, jsonQuery]
        guard let requestURL = components?.url else { completion([]); return }
        
        let dataTask = URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("Error getting representatives: \(error.localizedDescription)")
                completion([])
                return
            }
            guard let data = data,
                let responseDataString = String(data: data, encoding: .ascii),
                let fixedData = responseDataString.data(using: .utf8)
                else { completion([]); return }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let resultsDictionary = try jsonDecoder.decode([String: [Representative]].self, from: fixedData)
                let repArray = resultsDictionary["results"]
                completion(repArray ?? [])
            } catch {
                print("Error decoding json: \(error.localizedDescription)")
                completion([])
            }
        }
        dataTask.resume()
    }
}
