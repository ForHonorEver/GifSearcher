//
//  ImageHelper.swift
//  GifSearcher
//
//  Created by Yang, Zebin (Contractor) on 9/4/17.
//  Copyright © 2017 Yang, Zebin. All rights reserved.
//

import UIKit

class ImageHelper: NSObject {
    static let shared = ImageHelper()
    
    var storedGifs = [String: UIImage]()

    func fetchImageFrom(_ url: URL) -> UIImage? {
        if let image = storedGifs[url.absoluteString] {
            return image
        }
        
        if let image = UIImage.gif(url: url) {
            storedGifs[url.absoluteString] = image
            return image
        }
        
        return nil
    }
    
    func storeImageFor(_ url: URL) {
        if let image = UIImage.gif(url: url), storedGifs[url.absoluteString] == nil {
            storedGifs[url.absoluteString] = image
        }
    }
    
    
}
