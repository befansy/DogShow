//
//  NetworkService.swift
//  DogShow2
//
//  Created by Surgeont on 07.11.2021.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    private init() {
        
    }
    
    func getData(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
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
        }.resume()
    }
}
