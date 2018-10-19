//
//  ViewController.swift
//  Filter
//
//  Created by Sheng Tang on 12/10/18.
//  Copyright © 2018 Sheng. All rights reserved.

import UIKit

public protocol FilterControllerDelegate {
    func FilterControllerImageDidFilter(image: UIImage)
    func FilterControllerDidCancel()
}

class FilterController: UIViewController {
    @IBAction func cancleOnClick(_ sender: Any) {
        performSegueToReturnBack()
        print("you cancle")
    }
    
    @IBAction func nextOnClick(_ sender: Any) {
        performSegue(withIdentifier: "filterToPost", sender: nil)
    }
    
    @IBOutlet weak var imageView: UIImageView!

    
    @IBOutlet weak var collectionView: UICollectionView!
    public var delegate: FilterControllerDelegate?
    fileprivate let filterNameList = [
        "No Filter",
        "CISepiaTone",
        "CIPhotoEffectChrome",
        "CIFalseColor",
        "CIColorInvert",
        "CIPhotoEffectMono",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CILinearToSRGBToneCurve",
        "CISRGBToneCurveToLinear"
    ]
    
    fileprivate let filterDisplayNameList = [
        "Normal",
        "SepiaTone",
        "Chrome",
        "FalseColor",
        "ColorInvert",
        "Mono",
        "Fade",
        "Instant",
        "Noir",
        "Process",
        "Tonal",
        "Transfer",
        "Tone",
        "Linear"
    ]
    
    

    fileprivate var filterIndex = 0
    fileprivate let context = CIContext(options: nil)
    public var image: UIImage?
    fileprivate var smallImage: UIImage?
    fileprivate var cellSize = CGSize(width: 120, height: 164)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        smallImage = resizeImage(image: image!)
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        let imageRect = CGRect(x: 0, y: 64, width:screenWidth, height: screenWidth)
        let collectionRect = CGRect(x: 0, y: screenWidth+70, width: screenWidth, height: screenHeight-screenWidth-160)

        
        imageView.frame = imageRect
        collectionView.frame = collectionRect
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        // collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        
        
        let nib = UINib(nibName: "FilterCollectionViewCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "Cell")
        
        //add buttons
        let filterButton = UIButton()
        let filterButtonRect = CGRect(x: 40, y: screenHeight - 50, width: 100, height: 25)
        filterButton.frame = filterButtonRect
        filterButton.setTitle("Filter", for: .normal)
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.backgroundColor = .white
        filterButton.addTarget(self, action: #selector(filterOnClick), for: .touchUpInside)
        
        let editButton = UIButton()
        let editButtonRect = CGRect(x: screenWidth - 140, y: screenHeight - 50, width: 100, height: 25)
        editButton.frame = editButtonRect
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.black, for: .normal)
        editButton.backgroundColor = .white
        editButton.addTarget(self, action: #selector(editOnClick(_:)), for: .touchUpInside)
        
        self.view.addSubview(filterButton)
        self.view.addSubview(editButton)
    }
    
    @objc func filterOnClick(_ sender:Any){
        print("you choose filter")
    }
    
    @objc func editOnClick(_ sender:Any){
        performSegue(withIdentifier: "filterToEdit", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PostController{
            let image =  imageView.image!
            vc.SelectedImage = image
        }else if let vc = segue.destination as? CropController{
            let image =  imageView.image!
            vc.image = image
        }
    }
    
    func resizeImage(image: UIImage) -> UIImage {
        let ratio: CGFloat = 0.3
        let resizedSize = CGSize(width: Int(image.size.width * ratio), height: Int(image.size.height * ratio))
        UIGraphicsBeginImageContext(resizedSize)
        image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func initFilter(_ filterName: String) -> CIFilter {
        let filter = CIFilter.init(name: filterName)
        filter?.setDefaults()
        return filter!
    }
    
    func applyFilter(_ filterName: String, input: CIImage){
        let filter = initFilter(filterName)
        filter.setValue(input, forKey: kCIInputImageKey)
        let output = filter.outputImage
        self.imageView.image = UIImage(ciImage: output!)
    }
    
    func createFilteredImage(filterName: String, image: UIImage) -> UIImage {
        // 1 - create source image
        let sourceImage = CIImage(image: image)
        
        // 2 - create filter using name
        let filter = CIFilter(name: filterName)
        filter?.setDefaults()
        
        // 3 - set source image
        filter?.setValue(sourceImage, forKey: kCIInputImageKey)
        
        // 4 - output filtered image as cgImage with dimension.
        let outputCGImage = context.createCGImage((filter?.outputImage!)!, from: (filter?.outputImage!.extent)!)
        
        // 5 - convert filtered CGImage to UIImage
        let filteredImage = UIImage(cgImage: outputCGImage!)
        
        return filteredImage
    }
    
}

extension  FilterController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell :FilterCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FilterCollectionViewCell
        var filteredImage = smallImage
        if indexPath.row != 0 {
            filteredImage = createFilteredImage(filterName: filterNameList[indexPath.row], image: smallImage!)
        }
        
        cell.imageCell.image = filteredImage
        cell.filterName.text = filterDisplayNameList[indexPath.row]
        updateCellFont()
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterNameList.count
    }
    

    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        filterIndex = indexPath.row
        let originalCIImage = CIImage(image:image!)!;
        if filterIndex != 0 {
            let filterName = filterNameList[filterIndex]
            applyFilter(filterName,input:originalCIImage)
        } else {
            imageView?.image = UIImage(ciImage:CIImage(image:image!)!)
        }
        updateCellFont()
        scrollCollectionViewToIndex(itemIndex: indexPath.item)
    }
    
    func updateCellFont() {
        // update font of selected cell
        if let selectedCell = collectionView?.cellForItem(at: IndexPath(row: filterIndex, section: 0)) {
            let cell = selectedCell as! FilterCollectionViewCell
            cell.filterName.font = UIFont.boldSystemFont(ofSize: 14)
        }
        
        for i in 0...filterNameList.count - 1 {
            if i != filterIndex {
                // update nonselected cell font
                if let unselectedCell = collectionView?.cellForItem(at: IndexPath(row: i, section: 0)) {
                    let cell = unselectedCell as! FilterCollectionViewCell
                    cell.filterName.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.thin)
                    
                }
            }
        }
    }
    
    
    func scrollCollectionViewToIndex(itemIndex: Int) {
        let indexPath = IndexPath(item: itemIndex, section: 0)
        self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension FilterController{
    func performSegueToReturnBack(){
        if let nav = self.navigationController{
            nav.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}

