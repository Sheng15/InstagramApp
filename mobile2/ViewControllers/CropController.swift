//
//  CropController.swift
//  Crop
//
//  Created by username on 14/10/18.
//  Copyright © 2018 Sheng. All rights reserved.
//

import UIKit
import CoreImage

class CropController: UIViewController,UIScrollViewDelegate,UINavigationControllerDelegate {
    
    
    var imageView = UIImageView()
    var image : UIImage?
    
    var contrastFilter: CIFilter!;
    var brightnessFilter: CIFilter!;
    var outputImage :CIImage?;
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func cancleOnClick(_ sender: Any) {
        performSegueToReturnBack()
        print("you cancle")
    }
    
    @IBAction func nextOnClick(_ sender: UIButton) {
        performSegue(withIdentifier: "cropToPost", sender: nil)
    }
    
    @IBAction func brightnessSlider(_ sender: UISlider) {
        let beginImage = imageView.image
        print(sender.value)
        imageBrightness(imageView: imageView, sliderValue: CGFloat(sender.value),imageInput: beginImage!)
    }
   
    @IBAction func contrastSlider(_ sender: UISlider) {
        let beginImage = imageView.image
        imageContrast(imageView: imageView, sliderValue: CGFloat(sender.value),imageInput: beginImage!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        let width = scrollView.frame.size.width
        let height = scrollView.frame.size.height
        
        imageView.image = image
        
        imageView.frame = CGRect(x: 0, y: 0, width:image!.size.width, height: image!.size.height)
        
        
        imageView.isUserInteractionEnabled = true
        
        scrollView.addSubview(imageView)
        
        scrollView.contentSize = image!.size
        
        let scrollViewFrame = scrollView.frame
        let scaleWidth  = scrollViewFrame.size.width  / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth,scaleHeight)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 3
        scrollView.zoomScale = minScale
        
        centerScrollViewContents()
        
        brightnessFilter = CIFilter(name: "CIColorControls")
        contrastFilter = CIFilter(name: "CIColorControls")
        
    }
    
    func imageBrightness(imageView : UIImageView , sliderValue : CGFloat, imageInput: UIImage){
        let beginImage = CIImage(image: imageInput)
        brightnessFilter.setValue(beginImage, forKey:kCIInputImageKey)
        brightnessFilter.setValue(sliderValue, forKey: kCIInputBrightnessKey)
        if let ciimage = brightnessFilter.outputImage {
            outputImage = ciimage
            self.imageView.image = UIImage(ciImage: outputImage!)
        }
        print("brightness")
    }
    
    func imageContrast(imageView : UIImageView , sliderValue : CGFloat, imageInput: UIImage){
        let beginImage = CIImage(image: imageInput)
        contrastFilter.setValue(beginImage, forKey: kCIInputImageKey)
        contrastFilter.setValue(sliderValue, forKey: kCIInputContrastKey)
        if let ciimage = contrastFilter.outputImage {
            outputImage = ciimage
            self.imageView.image = UIImage(ciImage: outputImage!)
        }
        print("contrast")
    }
    
    func centerScrollViewContents(){
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width{
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width)/2
        } else{
            contentsFrame.origin.x = 0
        }
        
        if contentsFrame.size.height < boundsSize.height{
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height)/2
        } else{
            contentsFrame.origin.y = 0
        }
        imageView.frame = contentsFrame
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PostController{
            UIGraphicsBeginImageContextWithOptions(scrollView.bounds.size, true, UIScreen.main.scale)
            let offset = scrollView.contentOffset
            
            UIGraphicsGetCurrentContext()!.translateBy(x: -offset.x, y: -offset.y)
            scrollView.layer.render(in: UIGraphicsGetCurrentContext()!)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            vc.SelectedImage = image
        }else if let vc = segue.destination as? EditController{
            let image =  imageView.image!
            vc.image = image
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @IBAction func saveCropedImage(_ sender: UIButton) {
        UIGraphicsBeginImageContextWithOptions(scrollView.bounds.size, true, UIScreen.main.scale)
        let offset = scrollView.contentOffset
        
        UIGraphicsGetCurrentContext()!.translateBy(x: -offset.x, y: -offset.y)
        scrollView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Image Saved", message: "Saved to the album", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        
    }
    @IBAction func editOnClick(_ sender: UIButton) {
        performSegue(withIdentifier: "cropToEdit", sender: nil)
    }
    
}


extension CropController{
    
    func performSegueToReturnBack(){
        if let nav = self.navigationController{
            nav.popViewController(animated: true)
            
        }else{
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}
