//
//  NetworkingService.swift
//  HelixTask
//
//  Created by G.M on 12.05.21.
//

import Foundation

final class NetworkingService {
    
    private init() {}
    static let shared = NetworkingService()
    
    func request(_ urlPath: String, completion: @escaping (Result<Data, NSError>) -> Void) {
        
        guard let encodedUrlPath = urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: encodedUrlPath)!
        let session = URLSession.shared
        let task = session.dataTask(with: url) {(data, _, error) in
            
            if let unwrappedError = error {
                completion(.failure(unwrappedError as NSError))
            } else if let unwrappedData = data {
                completion(.success(unwrappedData))
            }
        }
        task.resume()
    }
    
    
}

