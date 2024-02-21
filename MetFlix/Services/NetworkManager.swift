//
//  NetworkManager.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 8.02.2024.
//

import Foundation
import UIKit


class NetworkManager {
    static let shared = NetworkManager()
    let cache = NSCache<NSURL, UIImage>()
    private let baseURL = "https://api.themoviedb.org/3/movie/"

    
    
    private init() {}
    
    
    func downloadImage(from url: URL, completion: @escaping(UIImage?) -> Void) {
        let cacheKey = NSURL(string: url.absoluteString)!
        
        if let image = cache.object(forKey: cacheKey) {
            completion(image)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completion(image)
        }
        task.resume()
    }
    
    
}
