//
//  FilterOperation.swift
//  PhotoQueue
//
//  Created by Jonathan Kopp on 6/30/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit
class FilterOperation: Operation
{
    var inputImage: UIImage?
    var outputImage: UIImage?
    
    init(image: UIImage? = nil) {
        inputImage = image
        super.init()
    }
    
    override func main() {
        let inputImage = CIImage(data:self.inputImage!.pngData()!)
        let context = CIContext(options:nil)
        let filter = CIFilter(name:"CIVignetteEffect")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter!.setValue(1.0, forKey: "inputIntensity")
        
        guard let outputImage = filter!.outputImage,
            let outImage = context.createCGImage(outputImage, from: outputImage.extent) else {
                return
        }
        self.outputImage =  UIImage(cgImage: outImage)
    }
}
