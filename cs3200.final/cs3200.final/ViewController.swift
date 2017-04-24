//
//  ViewController.swift
//  cs3200.final
//
//  Created by Student on 3/30/17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

var filters = [
    "CIPhotoEffectChrome",
    "CIPhotoEffectFade",
    "CIPhotoEffectInstant",
    "CIBumpDistortionLinear",
    "CICircleSplashDistortion",
    "CICircularWrap"
]

class ViewController: UIViewController {
    @IBOutlet weak var oldImage: UIImageView!
    @IBOutlet weak var newImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var scrollBar: UIScrollView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var x: CGFloat = 5
        let y: CGFloat = 5
        let width:CGFloat = 70
        let height: CGFloat = 70
        let gap: CGFloat = 5
        
        var count = 0
        
        for i in 0..<filters.count{
            count = i
            
            // Button properties
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(x: x, y: y, width: width, height: height)
            filterButton.tag = count
            filterButton.addTarget(self, action: #selector(ViewController.filterButtonTapped(_:)), for: .touchUpInside)
            filterButton.layer.cornerRadius = 6
            filterButton.clipsToBounds = true
            
            
            // Create filters for each button
            let ciContext = CIContext(options: nil)
            let coreImage = CIImage(image: oldImage.image!)
            let filter = CIFilter(name: "\(filters[i])" )
            filter!.setDefaults()
            filter!.setValue(coreImage, forKey: kCIInputImageKey)
            let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
            let imageForButton = UIImage(cgImage: filteredImageRef!)
            
            // Assign filtered image to the button
            filterButton.setBackgroundImage(imageForButton, for: .normal)
            
            // Add Buttons in the Scroll View
            x +=  width + gap
            scrollBar.addSubview(filterButton)
            
            }
        
        scrollBar.contentSize = CGSize(width: width * CGFloat(count+2), height: y)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func filterButtonTapped(_ sender: UIButton) {
        let button = sender as UIButton
        newImage.image = button.backgroundImage(for: UIControlState.normal)
    }

    
    @IBAction func saveImage(_ sender: Any) {
        // Save the image into camera roll
        UIImageWriteToSavedPhotosAlbum(newImage.image!, nil, nil, nil)
        
        let alert = UIAlertView(title: "Filters",
                                message: "Your image has been saved to Photo Library",
                                delegate: nil,
                                cancelButtonTitle: "OK")
        alert.show()
    }
}

