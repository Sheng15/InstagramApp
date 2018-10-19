//
//  ImagePickController.swift

//
//  ImagePickController.swift
//  mobile2
//
//  Created by Sheng Tang on 15/10/18.
//  Copyright © 2018 LudwiG. All rights reserved.
//

import UIKit
import Photos

class ImagePickController: UIViewController{
    
    var imageArray = [UIImage]()
    var width : CGFloat = 0.0
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideTabBar()
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 64)

        let photoRect = CGRect(x: 0, y: 64, width:screenWidth, height: screenWidth)
        let collectionRect = CGRect(x: 0, y: screenWidth+70, width: screenWidth, height: screenHeight-screenWidth-120)
        
        //add button
        let cameraButton = UIButton()
        let cameraButtonRect = CGRect(x: screenWidth - 140, y: screenHeight - 50, width: 100, height: 25)
        cameraButton.frame = cameraButtonRect
        cameraButton.setTitle("Camera", for: .normal)
        cameraButton.setTitleColor(.black, for: .normal)
        cameraButton.backgroundColor = .white
        cameraButton.addTarget(self, action: #selector(chooseCamera), for: .touchUpInside)
        
        let albumButton = UIButton()
        let albumButtonRect = CGRect(x: 40, y: screenHeight - 50, width: 100, height: 25)
        albumButton.frame = albumButtonRect
        albumButton.setTitle("Album", for: .normal)
        albumButton.setTitleColor(.black, for: .normal)
        albumButton.backgroundColor = .white
        albumButton.addTarget(self, action: #selector(chooseAlbum), for: .touchUpInside)
        
        
        
        self.view.addSubview(cameraButton)
        self.view.addSubview(albumButton)
        
        photoImageView.frame = photoRect
        collectionView.frame = collectionRect
        
        fetchPhotos()
        
        if !imageArray.isEmpty{
            photoImageView.image = imageArray[0]
        }
        
        
        let nib = UINib(nibName: "AlbumCollectionViewCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "Cell")
        
        
        
        //set up navigation in the top
        let cancleButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancleOnClick))
        let nextButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(nextOnClick(_:)))
        cancleButton.tintColor = UIColor.black
        nextButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = cancleButton
    
        self.navigationItem.rightBarButtonItem = nextButton
        
        //set up tab bar menu in bottom
        //let imageSourceNavigationController = UINavigationController(rootViewController: self)
        //imageSourceNavigationController.tabBarItem.title = "Album"
        //imageSourceNavigationController.tabBarItem.
    }
    
    func hideTabBar(){
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func cancleOnClick(_ sender:Any){
        self.dismiss(animated: true, completion: {})
        self.navigationController?.popViewController(animated: true)

    }
    
    @objc func nextOnClick(_ sender:Any){
        performSegue(withIdentifier: "albumToFilter", sender: nil)
    }
    
    @objc func chooseAlbum(){
        print ("chooseAlnum")
    }
    
    @objc func chooseCamera(){
        print ("chooseCamera")
        performSegue(withIdentifier: "albumToCamera", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FilterController{
            let image =  photoImageView.image!
            vc.image = image
        }
    }
    
    func fetchPhotos() {
        //hideNavigation()
        
        let imgManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .fastFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        if let fetchResult : PHFetchResult = PHAsset.fetchAssets(with: .image,options:fetchOptions){
            if fetchResult.count > 0{
                for i in 0..<fetchResult.count{
                    imgManager.requestImage(for: fetchResult.object(at: i) , targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions, resultHandler: {
                        
                        image, error in
                        self.imageArray.append(image!)
                    })
                }
            }
            else{
                print("not photo fetched!")
                self.collectionView?.reloadData()
            }
        }
    }
}

extension  ImagePickController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell :AlbumCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AlbumCollectionViewCell
        cell.albumCellView.image = imageArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        photoImageView.image = imageArray[index]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 4 - 1
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}


