//
//  NetworkRequest.swift
//  MortyAPI
//
//  Created by Егор Филиппов on 30.05.2022.
//

import Foundation


class NetworkRequest {
    static let shared = NetworkRequest()
    
    init() {}
    
    func requestData(completion: @escaping (Result<Data, Error>) -> Void) {
        
        let urlString = "https://test.kode-t.ru/recipes.json"
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        } .resume()
    }
}
