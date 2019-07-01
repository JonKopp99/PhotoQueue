//
//  DownloadOperation.swift
//  PhotoQueue
//
//  Created by Jonathan Kopp on 7/1/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit
class DownloadOperation: Operation
{
    var imgURL: URL?
    var outputImage: UIImage?
    
    init(image: URL? = nil) {
        imgURL = image
        super.init()
    }
    
    override func main() {
        var image : UIImage?
        let imageData = try? Data(contentsOf: imgURL!)
        image = UIImage(data:imageData!)
        self.outputImage =  image
    }
}
