//
//  splash_screen.swift
//  Badlee
//
//  Created by Mahendra on 09/02/18.
//  Copyright © 2018 Mahendra Vishwakarma. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class splash_screen: UIViewController,CLLocationManagerDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIScrollViewDelegate
{
    let locationManager = CLLocationManager()
    @IBOutlet weak var footerView: UIView!
    var visitedIndex = 0
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var paging: UIPageControl!
    
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        paging.numberOfPages = 4
        
        let userInfo = loginManager.isUserLogin()

        if((userInfo.object(forKey: "isLogin") as! Int) == 1)
        {
            let storyboard  = UIStoryboard.init(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "tabbarcontroller")
            appDel.window?.rootViewController = viewController
            appDel.window?.makeKeyAndVisible()
        }

        
        //locationManager.requestWhenInUseAuthorization()
        
        //locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
       // locationManager.delegate = self
        
//        if(CLLocationManager.locationServicesEnabled() == true)
//        {
//            locationManager.startUpdatingLocation()
//        }
        
      
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SplashScreenCell
        cell.images.image = UIImage(named: "screen\(indexPath.row+1)")
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: self.view.frame.height-self.view.safeAreaInsets.top-self.view.safeAreaInsets.bottom)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        navigationVC.sharedInstance.lat  = locValue.latitude
        navigationVC.sharedInstance.long = locValue.longitude
        
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @objc func update_offset()
    {
        self.performSegue(withIdentifier: "letsBadlee", sender: nil)
    }
    
    @IBAction func btnNext(_ sender: Any) {
        visitedIndex += 1
        if(visitedIndex > 3)
        {
             self.performSegue(withIdentifier: "letsBadlee", sender: nil)
             return
        }
        collectionview.scrollToItem(at: IndexPath(item: visitedIndex, section: 0), at: .centeredHorizontally, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       let pageNumber = round(scrollView.contentOffset.x/view.frame.width)
        paging.currentPage = Int(pageNumber)
        visitedIndex = Int(pageNumber)
        btnNext.setTitle("NEXT", for: .normal)
        btnNext.setTitleColor(UIColor.white, for: .normal)
        btnSkip.isHidden = false
        if(visitedIndex == 3){
            btnNext.setTitleColor(UIColor.black, for: .normal)
            btnNext.setTitle("START", for: .normal)
            btnSkip.isHidden = true
        }
        
    }
    
    @IBAction func btnSkip(_ sender: Any) {
         self.performSegue(withIdentifier: "letsBadlee", sender: nil)
    }
    
}
