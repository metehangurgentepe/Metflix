//
//  ImageLoader.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 28.01.2024.
//

import Foundation
import UIKit

private let _imageCache = NSCache<AnyObject, AnyObject>()

class ImageLoader {
    var image: UIImage?
    var isLoading = false
    
    var imageCache = _imageCache
    
    func loadImage(with url: URL){
        let urlString = url.absoluteString
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else { return }
                self.imageCache.setObject(image, forKey: urlString as AnyObject)
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
