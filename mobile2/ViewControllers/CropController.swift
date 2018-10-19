//
//  CropController.swift
//  Crop
//
//  Created by username on 14/10/18.
//  Copyright © 2018 Sheng. All rights reserved.
//

import UIKit

class CropController: UIViewController,UIScrollViewDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func cancleOnClick(_ sender: Any) {
        performSegueToReturnBack()
        print("you cancle")
    }
    
    @IBAction func nextOnClick(_ sender: UIButton) {
        performSegue(withIdentifier: "editToPost", sender: nil)
    }
    
    var imageView = UIImageView()
    var image : UIImage?
    
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
