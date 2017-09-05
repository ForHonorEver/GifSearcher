//
//  GifTableViewCell.swift
//  GifSearcher
//
//  Created by Yang, Zebin (Contractor) on 9/4/17.
//  Copyright © 2017 Yang, Zebin. All rights reserved.
//

import UIKit

class GifTableViewCell: UITableViewCell {

    @IBOutlet weak var imageToDisplay: UIImageView!
    
    static let Identifier = "GifCell"
    
    func configureWithGif(_ gif: Gif) {
        
        guard let url = gif.url, let image = ImageHelper.shared.fetchImageFrom(url) else { return }
        self.backgroundView?.backgroundColor = UIColor.yellow
        DispatchQueue.main.async{
            self.imageToDisplay.image = image
        }
    }
}
