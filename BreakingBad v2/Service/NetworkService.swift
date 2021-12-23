//
//  NetworkService.swift
//  BreakingBad v2
//
//  Created by Максим on 02/12/2021.
//

//https://www.breakingbadapi.com/api/
// api/character/random
// api/quote/random
import UIKit

class NetworkService {
    
    func requestRandomCharacter(random: Random, complition: @escaping (Data?, Error?)-> Void) {
        guard let url = self.urlRandomCharacter(random: random) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "get"
        let task = createDataTask(from: request, complition: complition)
        task.resume()
    }
    //  For Random
    private func urlRandomCharacter(random: Random) -> URL? {
        var components = URLComponents()
        let path = random.rawValue
        components.scheme = "https"
        components.host = "breakingbadapi.com"
        components.path = path
        return components.url
    }
    
    //    MARK: - Create Task
    private func createDataTask(from request: URLRequest, complition: @escaping (Data?, Error?)->Void) -> URLSessionTask
    {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                complition(data, error)
            }
        }
    }
}

enum Random: String {
    case characterRandom = "/api/character/random"
    case quoteRandom = "/api/quote/random"
}
