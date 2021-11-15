//
//  LoadAndCashImages.swift
//  DogShow2
//
//  Created by Surgeont on 07.11.2021.
//

import UIKit

class LoadAndCashImages {
    
    static let shared = LoadAndCashImages()
    private init() {
        
    }
    
    var imageCash = NSCache<NSString, UIImage>()
    
    func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        
        if let cachedImage = imageCash.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
            print("fromCache")
        } else {
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard error == nil,
                      data != nil,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else { return }
                guard let image = UIImage(data: data!) else { return }
                self?.imageCash.setObject(image, forKey: url.absoluteString as NSString)
                
                DispatchQueue.main.async {
                    completion(image)
                    print("loaded")
                }
            }.resume()
        }
    }
}
