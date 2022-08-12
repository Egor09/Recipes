//
//  NetworkImageRequest.swift
//  MortyAPI
//
//  Created by Егор Филиппов on 30.05.2022.
//

import Foundation

class NetworkImageRequest {
    
    static let shared = NetworkImageRequest()
    init() {}
    
    func requestData(from urlString: [String], completion: @escaping (Result<Data, Error>) -> Void) {
        
        for urlString in urlString {
            let session = URLSession.shared
            let url = URL(string: urlString)
            
            let task = session.dataTask(with: url!) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    guard let data = data else { return }
                    completion(.success(data))
                }
            }
            task.resume()
        }
    }
}
