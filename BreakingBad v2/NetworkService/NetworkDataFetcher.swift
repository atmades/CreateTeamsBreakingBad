//
//  NetworkDataFetcher.swift
//  BreakingBad v2
//
//  Created by Максим on 02/12/2021.
//

import UIKit

protocol NetworkDataFetcher {
    func fetchRandomPhotos(random: Random,complition: @escaping ([Character]?) -> ())
    func fetchRandomQuote(random: Random,complition: @escaping ([Quote]?) -> ())
}

class NetworkDataFetcherImpl: NetworkDataFetcher {
    
    var networkService = NetworkService()
    
    //  For Random
    func fetchRandomPhotos(random: Random,complition: @escaping ([Character]?) -> ()) {
        networkService.requestRandomCharacter(random: random) { (data, error) in
            if let error = error {
                print("Error recived requesting data: \(error.localizedDescription)")
                complition(nil)
            }
            let decode = self.decodeJSON(type: [Character].self, from: data)
            complition(decode)
        }
    }
    
    func fetchRandomQuote(random: Random,complition: @escaping ([Quote]?) -> ()) {
        networkService.requestRandomCharacter(random: random) { (data, error) in
            if let error = error {
                print("Error recived requesting data: \(error.localizedDescription)")
                complition(nil)
            }

            let decode = self.decodeJSON(type: [Quote].self, from: data)
            complition(decode)
        }
    }
    
    //    MARK: - Decode Generic
        func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
            let decoder = JSONDecoder()
            guard let data = from else { return nil }
            do {
                let objects = try decoder.decode(type.self, from: data)
                return objects
            } catch let jsonError {
                print("Failed to decode JSON", jsonError)
                return nil
            }
        }
}
