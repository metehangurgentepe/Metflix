//
//  ImageLoader.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 10.10.2024.
//

import Foundation
import UIKit
import SDWebImage

protocol ImageLoaderProtocol {
    func loadImage(with url: URL?, completion: @escaping (Result<UIImage, Error>) -> Void)
}

class SDWebImageLoader: ImageLoaderProtocol {
    func loadImage(with url: URL?, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = url else {
            completion(.failure(MovieError.serializationError))
            return
        }
        
        SDWebImageManager.shared.loadImage(
            with: url,
            options: .highPriority,
            progress: nil
        ) { (image, _, error, _, _, _) in
            if let image = image {
                completion(.success(image))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(MovieError.serializationError))
            }
        }
    }
}
