//
//  NetworkDataFetch.swift
//  MortyAPI
//
//  Created by Егор Филиппов on 30.05.2022.
//

import Foundation
import UIKit


class NetworkDataFetch {
    static let shared = NetworkDataFetch()
    
    private init() {}
    
    func fetchRecept(response: @escaping (ReceptModel?, Error?) -> Void)  {
        NetworkRequest.shared.requestData { result in
            switch result {
                
            case .success(let data):
                do {
                    let recept = try JSONDecoder().decode(ReceptModel.self, from: data)
                    response(recept, nil)
                } catch let jsonError {
                    print("FAILLL", jsonError)
                }
            case .failure(let error):
                print("error \(error.localizedDescription)")
                response(nil, error)
            }
        }
    }
}
