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
    var slider = CustomSlider()
    var label = UILabel()
    var oldSliderValuue = Int()
    var reloadButton = UIButton()
    var activity = UIActivityIndicatorView()
    var activityTimer = Timer()
    var activityHue = 0
    var filterButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        activityTimer = Timer(timeInterval: 0.01, target: self, selector: #selector(colorWheel), userInfo: nil, repeats: true)
        downloadPhotosFromPlist()
        tb.dataSource = self
        tb.delegate = self
        
        tb.register(PhotoCell.self, forCellReuseIdentifier: "PhotoCell")
        tb.frame = CGRect(x: 0, y: 100, width: self.view.bounds.width, height: self.view.bounds.height - 100)
        
        self.view.addSubview(tb)
        setUpTableHeader()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func setUpTableHeader()
    {
        let theview = UIView(frame: (CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 150)))
        label = UILabel(frame: CGRect(x: 10, y: 30, width: self.view.bounds.width - 20, height: 30))
        label.text = "Download \(Int(slider.value)) photos"
        label.textAlignment = .center
        theview.addSubview(label)
        oldSliderValuue = 0
        slider.frame = CGRect(x: 10, y: 50, width: self.view.bounds.width - 20, height: 30)
        slider.trackWidth = 10
        slider.minimumValue = 0
        slider.maximumValue = 9
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        theview.addSubview(slider)
        reloadButton = UIButton()
        reloadButton.frame = CGRect(x: self.view.bounds.width / 2 + 5, y: 90, width: 180, height: 50)
        reloadButton.backgroundColor = #colorLiteral(red: 0.09029659377, green: 0.456161131, blue: 1, alpha: 1).withAlphaComponent(0.9)
        reloadButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 20.0)
        reloadButton.titleLabel?.adjustsFontSizeToFitWidth = true
        reloadButton.setTitle("Reload", for: .normal)
        reloadButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        reloadButton.addTarget(self, action:#selector(self.reloadPressed), for: .touchUpInside)
        reloadButton.layer.cornerRadius = 20
        reloadButton.layer.borderWidth = 2
        reloadButton.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        reloadButton.alpha = 0.0
        reloadButton.isEnabled = false
        filterButton.backgroundColor = #colorLiteral(red: 0.09029659377, green: 0.456161131, blue: 1, alpha: 1).withAlphaComponent(0.9)
        filterButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 20.0)
        filterButton.titleLabel?.adjustsFontSizeToFitWidth = true
        filterButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        filterButton.layer.borderWidth = 2
        filterButton.layer.cornerRadius = 20
        filterButton.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        filterButton.alpha = 0.0
        filterButton.isEnabled = false
        filterButton.setTitle("Filter", for: .normal)
        filterButton.addTarget(self, action:#selector(self.startFilter), for: .touchUpInside)
        filterButton.frame = CGRect(x: self.view.bounds.width / 2 - 190, y: 90, width: 180, height: 50)
        theview.addSubview(filterButton)
        activity.frame = CGRect(x: self.view.bounds.width / 2 - 90, y: 70, width: 180, height: 50)
        theview.addSubview(activity)
        activity.alpha = 0.0
        activity.isHidden = true
        activity.color = .black
        theview.addSubview(reloadButton)
        self.view.addSubview(theview)
    }
    @objc func sliderValueDidChange(_ sender: UISlider!)
    {
        let theValue = Int(sender.value)
        label.text = "Download \(theValue) photos"
        if(theValue != oldSliderValuue)
        {
            oldSliderValuue = theValue
            reloadView()
        }
    }
    func reloadView()
    {
        self.reloadButton.isEnabled = true
        UIView.animate(withDuration: 0.3, animations: {
            self.tb.frame = CGRect(x: 0, y: 150, width: self.view.bounds.width, height: self.view.bounds.height - 150)
            self.reloadButton.alpha = 1.0
            })
    }
    @objc func reloadPressed()
    {
        print("reload pressed")
        reloadButton.isEnabled = false
        self.activity.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.reloadButton.alpha = 0.0
            self.activity.alpha = 1.0
        }, completion: { (finished: Bool) in
            DispatchQueue.main.async{
                self.activity.color = .purple
            self.activity.startAnimating()
            self.scheduledTimerWithTimeInterval()
            self.tb.reloadData{
                self.activity.stopAnimating()
                self.activityTimer.invalidate()
                self.activity.isHidden = true
                print("FINISHED")
                self.filterButton.isEnabled = true
                UIView.animate(withDuration: 0.3, animations: {
                    self.filterButton.alpha = 1.0
                    })
                }
            }
        })
        
    }
    @objc func startFilter()
    {
        UIView.animate(withDuration: 0.3, animations: {
            self.filterButton.alpha = 0.0
        }, completion: { (finished: Bool) in
            self.filterButton.isEnabled = false
            self.activity.isHidden = false
            self.activity.startAnimating()
            
            self.scheduledTimerWithTimeInterval()
            let cells = self.tb.visibleCells as! [PhotoCell]
            let sem = DispatchSemaphore(value: cells.count)
            var ctr = 0
            for cell in cells
            {
                DispatchQueue.main.async {
                    sem.wait()
                    sleep(1)
                    let op = FilterOperation()
                    //cell.imgView.image = self.applySepiaFilter((cell.imgView.image)!)
                    
                    op.inputImage = (cell.imgView.image)!
                    op.start()
                    cell.imgView.image = op.outputImage
                    sem.signal()
                    if(ctr < cells.count){
                        self.activity.stopAnimating()
                        self.activityTimer.invalidate()
                        self.activity.isHidden = true
                    }
                    ctr += 1
                }
            }
        })
        
        
            
        
        
        
        print("NUMSECTIONS", tb.numberOfSections)
        
    }
    func scheduledTimerWithTimeInterval(){
        //if timer running is > 10 exit's queue!!! else search for user!
        self.activityTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: {_ in
           self.colorWheel()
        })
    }
    @objc func colorWheel()
    {
        if(self.activity.isAnimating == false)
        {
            self.activityTimer.invalidate()

            print("Stopped")
            return
        }
        print("Timer Triiggerd")
        if(self.activityHue >= 359)
        {
            self.activityHue = 0
        }
        self.activity.color = UIColor(hue: (CGFloat(self.activityHue ) * 0.01), saturation: CGFloat(1.0), brightness: CGFloat(1.0), alpha: 1.0)
        self.activityHue += 1
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
        return Int(slider.value)
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
    
    func applySepiaFilter(_ image:UIImage) -> UIImage? {
        let inputImage = CIImage(data:image.pngData()!)
        let context = CIContext(options:nil)
        let filter = CIFilter(name:"CISepiaTone")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter!.setValue(1.0, forKey: "inputIntensity")
        
        guard let outputImage = filter!.outputImage,
            let outImage = context.createCGImage(outputImage, from: outputImage.extent) else {
                return nil
        }
        return UIImage(cgImage: outImage)
    }
   


}

open class CustomSlider : UISlider {
    @IBInspectable open var trackWidth:CGFloat = 2 {
        didSet {setNeedsDisplay()}
    }
    
    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        let defaultBounds = super.trackRect(forBounds: bounds)
        return CGRect(
            x: defaultBounds.origin.x,
            y: defaultBounds.origin.y + defaultBounds.size.height/2 - trackWidth/2,
            width: defaultBounds.size.width,
            height: trackWidth
        )
    }
}
extension UITableView {
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
}
