//
//  ViewController.swift
//  PhotoQueue
//
//  Created by Jonathan Kopp on 6/30/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tb = UITableView()
    var photosDict: [String: String] = [:]
    lazy var photos = NSDictionary(dictionary: photosDict)
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadPhotosFromPlist()
        tb.dataSource = self
        tb.delegate = self
        
        tb.register(PhotoCell.self, forCellReuseIdentifier: "PhotoCell")
        tb.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        
        self.view.addSubview(tb)
        
    }
    
    func downloadPhotosFromPlist()
    {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let plist = Bundle.main.url(forResource: "PhotosDictionary", withExtension: "plist"),
                let contents = try? Data(contentsOf: plist),
                let serializedPlist = try? PropertyListSerialization.propertyList(from: contents, format: nil),
                let serialUrls = serializedPlist as? [String: String] else {
                    print("error with serializedPlist")
                    return
            }
            self.photosDict = serialUrls
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        let rowKey = photos.allKeys[indexPath.row] as! String
        
        var image : UIImage?
        DispatchQueue.global().async {
            guard let imageURL = URL(string:self.photos[rowKey] as! String),
                let imageData = try? Data(contentsOf: imageURL)
                else {return}
            image = UIImage(data:imageData)
            DispatchQueue.main.async {
                if image != nil {
                    cell.imgView.image = image!
                }
            }
            
        }
        return cell
    }
    

   


}

