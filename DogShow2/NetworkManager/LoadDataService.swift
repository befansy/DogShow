//
//  LoadDataService.swift
//  DogShow2
//
//  Created by Surgeont on 07.11.2021.
//

import Foundation

class LoadDataService {
    
    static let shared = LoadDataService()
    private init() {
        
    }
    
    func loadBreeds(urlString: String, response: @escaping (Response?, Error?) -> Void) {
        NetworkService.shared.getData(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let dogs = try JSONDecoder().decode(Response.self, from: data)
                    response(dogs, nil)
                } catch let responseError {
                    print("Wrong in decoding \(responseError.localizedDescription)")
                }
            case .failure(let error):
                print("Wrong in Search Service \(error.localizedDescription)")
                response(nil, error)
            }
        }
    }
    
    func loadImages(urlString: String, response: @escaping (ImagesResponse?, Error?) -> Void) {
        NetworkService.shared.getData(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let images = try JSONDecoder().decode(ImagesResponse.self, from: data)
                    response(images, nil)
                } catch let responseError {
                    print("Wrong in decoding \(responseError.localizedDescription)")
                }
            case .failure(let error):
                print("Wrong in Search Service \(error.localizedDescription)")
                response(nil, error)
            }
        }
    } 
}
