//
//  GalleryViewController.swift
//  Badlee
//
//  Created by Mahendra Vishwakarma on 03/07/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import UIKit
import Photos

class GalleryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionview: UICollectionView!
     var photos : PHFetchResult<PHAsset>?
     var selected_postitem:String!
     var homeObject:AnyObject!
    override func viewDidLoad() {
        super.viewDidLoad()
       checkAuthorizationForPhotoLibraryAndGet()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       self.tabBarController?.tabBar.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
   
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    private func getPhotosAndVideos(){
        
        DispatchQueue.main.async {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",ascending: false)]
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            self.photos = PHAsset.fetchAssets(with: fetchOptions)
            self.collectionview.reloadData()
        }
       
        
       // print(imagesAndVideos.count)
    }
    
    private func checkAuthorizationForPhotoLibraryAndGet(){
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            // Access has been granted.
            getPhotosAndVideos()
        }else {
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    self.getPhotosAndVideos()
                }else {
                    
                }
            })
        }
    }
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = photos?.count else{
            return 0
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! imageCell
        let assest = photos?.object(at: indexPath.row)
        cell.image.layer.cornerRadius = 8
        cell.image.layer.masksToBounds = true
        
        let options = PHImageRequestOptions()
        options.version = .current
        options.resizeMode = .fast
        options.deliveryMode = .opportunistic
        options.isSynchronous = true
        options.isNetworkAccessAllowed = false
        
        PHImageManager.default().requestImageData(for: assest!, options: options) { data, uti, orientation, info in
            guard let data =  data else{
                return
            }
            
            guard let image = UIImage(data: data) else{
                return
            }
            
            cell.image.image = image
            
        }
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let assest = photos?.object(at: indexPath.row)
       
        let options = PHImageRequestOptions()
        options.version = .current
        options.resizeMode = .fast
        options.deliveryMode = .opportunistic
        options.isSynchronous = true
        options.isNetworkAccessAllowed = false
        
        PHImageManager.default().requestImageData(for: assest!, options: options) { data, uti, orientation, info in
            guard let data =  data else{
                return
            }
            
            guard let image = UIImage(data: data) else{
                return
            }
            
            let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
            
            let object_postitem = strbrd.instantiateViewController(withIdentifier: "imageOrientationVC") as! imageOrientationVC
            object_postitem.selected_imagename = self.selected_postitem
            object_postitem.img_selected = image
            object_postitem.homeObject = self.homeObject

            self.navigationController?.pushViewController(object_postitem, animated: true)
           
            
        }
    }
}
