//
//  ImageService.swift
//  SampleApplication
//
//  Created by jabari on 1/30/21.
//

import Foundation
import Fundamentals
import UIKit

// MARK: - ImageService

final class ImageService {
    @Inject private var logger: Logger
    
    func load(from url: URL) -> Task<UIImage, Error> {
        return Task<UIImage, Error> { completion in
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, let image = UIImage(data: data) else {
                    let e = error ?? NSError(domain: "image-downoad-failed", code: 1, userInfo: nil)
                    self?.logger.error(e)
                    completion(.failure(e))
                    return
                }
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            }.resume()
        }
    }
}
