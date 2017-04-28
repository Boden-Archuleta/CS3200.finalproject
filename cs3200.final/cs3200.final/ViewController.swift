//
//  ViewController.swift
//  cs3200.final
//
//  Created by Student on 4/27/17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

var filterList = [
    "CIPhotoEffectChrome",
    "CIPhotoEffectFade",
    "CIPhotoEffectInstant",
    "CIPhotoEffectTransfer",
    ]

class ViewController: UIViewController {
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var oldPicture: UIImageView!
    @IBOutlet weak var newPicture: UIImageView!
    @IBOutlet weak var scrollBar: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        var x: CGFloat = 5
        let y: CGFloat = 5
        let w:CGFloat = 70
        let h: CGFloat = 70
        let gap: CGFloat = 5
        var count = 0
        
        
        //custom red - green filter
        let filterButton = UIButton(type: .custom)
        filterButton.frame = CGRect(x: x, y: y, width: w, height: h)
        filterButton.tag = count
        filterButton.addTarget(self, action: #selector(ViewController.filterButtonTapped(_:)), for: .touchUpInside)
        filterButton.layer.cornerRadius = 6
        filterButton.clipsToBounds = true
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: oldPicture.image!)
        let filter = RedGreen()
        filter.setValue(coreImage, forKey: kCIInputImageKey)
        let filteredImageData = filter.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        let imageForButton = UIImage(cgImage: filteredImageRef!)
        filterButton.setBackgroundImage(imageForButton, for: .normal)
        x +=  w + gap
        scrollBar.addSubview(filterButton)
        count = count + 1
        
        //custom blue - yellow filter
        let filterButton2 = UIButton(type: .custom)
        filterButton2.frame = CGRect(x: x, y: y, width: w, height: h)
        filterButton2.tag = count
        filterButton2.addTarget(self, action: #selector(ViewController.filterButtonTapped(_:)), for: .touchUpInside)
        filterButton2.layer.cornerRadius = 6
        filterButton2.clipsToBounds = true
        let ciContext2 = CIContext(options: nil)
        let coreImage2 = CIImage(image: oldPicture.image!)
        let filter2 = BlueYellow()
        filter2.setValue(coreImage2, forKey: kCIInputImageKey)
        let filteredImageData2 = filter2.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef2 = ciContext2.createCGImage(filteredImageData2, from: filteredImageData2.extent)
        let imageForButton2 = UIImage(cgImage: filteredImageRef2!)
        filterButton2.setBackgroundImage(imageForButton2, for: .normal)
        x +=  w + gap
        scrollBar.addSubview(filterButton2)
        count = count + 1
        
        //custom monochrom filter
        let filterButton3 = UIButton(type: .custom)
        filterButton3.frame = CGRect(x: x, y: y, width: w, height: h)
        filterButton3.tag = count
        filterButton3.addTarget(self, action: #selector(ViewController.filterButtonTapped(_:)), for: .touchUpInside)
        filterButton3.layer.cornerRadius = 6
        filterButton3.clipsToBounds = true
        let ciContext3 = CIContext(options: nil)
        let coreImage3 = CIImage(image: oldPicture.image!)
        let filter3 = MonoChrom()
        filter3.setValue(coreImage3, forKey: kCIInputImageKey)
        let filteredImageData3 = filter3.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef3 = ciContext3.createCGImage(filteredImageData3, from: filteredImageData3.extent)
        let imageForButton3 = UIImage(cgImage: filteredImageRef3!)
        filterButton3.setBackgroundImage(imageForButton3, for: .normal)
        x +=  w + gap
        scrollBar.addSubview(filterButton3)
        count = count + 1
        
        //update scrollbar
        scrollBar.contentSize = CGSize(width: w * CGFloat(count+2), height: y)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func filterButtonTapped(_ sender: UIButton) {
        let button = sender as UIButton
        newPicture.image = button.backgroundImage(for: UIControlState.normal)
    }
    
}

class RedGreen: CIFilter {
    var inputImage: CIImage?
    func createCustomKernel() -> CIColorKernel {
        let kernelString =
            "kernel vec4 chromaKey( __sample s) { \n" +
                "  vec4 newPixel = s.rgba;" +
                "  if (newPixel[0] > newPixel[1]) {" +
                "  newPixel[0] = newPixel[0] * 2.0;" +
                "  newPixel[1] = newPixel[1] / 2.0;" +
                "  return newPixel;\n" +
                "  }" +
                "  newPixel[1] = newPixel[1] * 2.0;" +
                "  newPixel[0] = newPixel[0] / 2.0;" +
                "  return newPixel;\n" +
        "}"

        return CIColorKernel(string: kernelString)!
    }
    
    override public var outputImage: CIImage! {
        get {
            if let inputImage = self.inputImage {
                let args = [inputImage as AnyObject]
                return createCustomKernel().apply(withExtent: inputImage.extent, arguments: args)
            } else {
                return nil
            }
        }
    }
}

class BlueYellow: CIFilter {
    var inputImage: CIImage?
    func createCustomKernel() -> CIColorKernel {
        let kernelString =
            "kernel vec4 chromaKey( __sample s) { \n" +
                "  vec4 newPixel = s.rgba;" +
                "  if (newPixel[2] > newPixel[0] && newPixel[2] > newPixel[1]) {" +
                "  newPixel[2] = newPixel[2] * 2.0;" +
                "  return newPixel;\n" +
                "  }" +
                "  newPixel[1] = newPixel[1] * 2.0;" +
                "  newPixel[0] = newPixel[0] * 2.0;" +
                "  return newPixel;\n" +
        "}"
        return CIColorKernel(string: kernelString)!
    }
    
    override public var outputImage: CIImage! {
        get {
            if let inputImage = self.inputImage {
                let args = [inputImage as AnyObject]
                return createCustomKernel().apply(withExtent: inputImage.extent, arguments: args)
            } else {
                return nil
            }
        }
    }
}

class MonoChrom: CIFilter {
    var inputImage: CIImage?
    func createCustomKernel() -> CIColorKernel {
        let kernelString =
            "kernel vec4 chromaKey( __sample s) { \n" +
                "  vec4 newPixel = s.rgba;" +
                "  if (newPixel[0] > newPixel[1]) {" +
                "  newPixel[0] = 255.0;" +
                "  newPixel[1] = 255.0;" +
                "  newPixel[2] = 255.0;" +
                "  return newPixel;\n" +
                "  }" +
                "  return newPixel;\n" +
        "}"
        return CIColorKernel(string: kernelString)!
    }
    
    override public var outputImage: CIImage! {
        get {
            if let inputImage = self.inputImage {
                let args = [inputImage as AnyObject]
                return createCustomKernel().apply(withExtent: inputImage.extent, arguments: args)
            } else {
                return nil
            }
        }
    }
}





