//
//  EditController.swift
//  mobile2
//
//  Created by username on 21/10/18.
//  Copyright © 2018 LudwiG. All rights reserved.
//

import UIKit

class EditController: UIViewController {
    
    var image : UIImage!
    
    var contrastFilter: CIFilter!;
    var brightnessFilter: CIFilter!;
    var outputImage :CIImage!;
    
    @IBAction func cancleOnclick(_ sender: UIButton) {
        performSegueToReturnBack()
        print("you cancle")
    }
    @IBAction func nextOnClick(_ sender: UIButton) {
        performSegue(withIdentifier: "editToPost", sender: nil)

    }
    
    @IBAction func brightnessSlider(_ sender: UISlider) {
        imageBrightness(imageView: imageView, sliderValue: CGFloat(sender.value), imageInput: image)
    }
    @IBAction func contrastSlider(_ sender: UISlider) {
        imageContrast(imageView: imageView, sliderValue: CGFloat(sender.value), imageInput: image)
    }
    
    @IBAction func saveOnClick(_ sender: UIButton) {
        let image = imageView.image
        
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Image Saved", message: "Saved to the album", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
    }
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let screenWidth = UIScreen.main.bounds.size.width
        imageView.frame = CGRect(x: 0, y: 64, width:screenWidth, height: screenWidth)
        imageView.image = image
        
        
        brightnessFilter = CIFilter(name: "CIColorControls")
        contrastFilter = CIFilter(name: "CIColorControls")
    }
    
    func imageBrightness(imageView : UIImageView , sliderValue : CGFloat, imageInput: UIImage){
        let beginImage = CIImage(image: imageInput)
        brightnessFilter.setValue(beginImage, forKey:kCIInputImageKey)
        let brightness: Float = Float(sliderValue/200)
        print(brightness)
        brightnessFilter.setValue(brightness, forKey: kCIInputBrightnessKey)
        if let ciimage = brightnessFilter.outputImage {
            outputImage = ciimage
            imageView.image = UIImage(ciImage: outputImage)
        }
        print("brightness")
    }
    
    func imageContrast(imageView : UIImageView , sliderValue : CGFloat, imageInput: UIImage){
        let beginImage = CIImage(image: imageInput)
        contrastFilter.setValue(beginImage, forKey: kCIInputImageKey)
        let contrast: Float = Float((sliderValue/200) * 200)
        print(contrast)
        contrastFilter.setValue(contrast, forKey: kCIInputContrastKey)
        if let ciimage = contrastFilter.outputImage {
            outputImage = ciimage
            imageView.image = UIImage(ciImage: outputImage)
        }
        print("contrast")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PostController{
            let image =  imageView.image!
            vc.SelectedImage = image
        }
    }
}

extension EditController{
    
    func performSegueToReturnBack(){
        if let nav = self.navigationController{
            nav.popViewController(animated: true)
            
        }else{
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}
