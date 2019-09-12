//
//  search.swift
//  Badlee
//
//  Created by Mahendra on 09/12/17.
//  Copyright © 2017 Mahendra Vishwakarma. All rights reserved.
//

import UIKit

class search: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    var arrData = NSArray()
    var arrFilteredData = NSArray()
    var isSelected = false
    var reaction:String!
    var locationName:String!
    var categoryName:String!
    var lastOffset_y :CGFloat!
    var offset_up:CGFloat!
    var offset_down:CGFloat!
    var net_down:CGFloat!
    var net_up:CGFloat!
     var object_parent:home!
    var customDelegateForDataReturn: TrendingProductsCustomDelegate?
    
    @IBOutlet weak var btnShout: UIImageView!
    @IBOutlet weak var btnLend: UIImageView!
    @IBOutlet weak var btnCategories: UIButton!
    @IBOutlet weak var btnShow: UIImageView!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var search_collection: UICollectionView!
    var postButton = UIButton()
    var origin :CGPoint!
    private var lastContentOffset: CGFloat = 0
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    
        self.getupdatedDate_all()

    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool)
    {
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       // postButton.removeTarget(self, action: #selector(lets_search_item), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
 
    @objc func lets_search_item()
    {
        self.performSegue(withIdentifier: "search_item", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let object = segue.destination as! search_itemVC
        object.mainData = arrData
    }
    
    func getupdatedDate_all()
    {
         comman.showLoader(toView: self)
        web_services.badlee_post_without_auth(page_url: "posts.php", succuss: { (data) in
            
            self.arrData = data as! NSArray
            self.arrFilteredData = self.arrData
            self.search_collection.reloadData()
            comman.hideLoader(toView: self)
           
            
        }) { (data) in
            comman.hideLoader(toView: self)
           
        }
    }
    
  
    func sendDataBackToHomePageViewController(data: String?)
    {
       btnCategories.setTitle(data, for: .normal)
        if(data != "Category")
        {
            categoryName = data
        }
        else
        {
            categoryName = nil
        }
    }
    
    
    
    
    //MARK: - collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let size =  UIScreen.main.bounds.width/3 - 15
        
     return CGSize(width: size, height: size)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFilteredData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let img_item = cell.viewWithTag(1) as! UIImageView
        let img_purpose = cell.viewWithTag(2) as! UIImageView
        
        if(isSelected)
        {
            img_purpose.isHidden = true
        }
        else
        {
            img_purpose.isHidden = false
        }
        
        let item_str_url = StaticURLs.base_url + ((arrFilteredData[indexPath.row] as! NSDictionary).object(forKey: "media") as! String)
        let item_url = URL.init(string: item_str_url)
        
        img_item.image = nil
        
        if(item_url != nil)
        {
            img_item.setImageWith(item_url!, placeholderImage: nil)
        }
        
        let reaction_name = (arrFilteredData[indexPath.row] as! NSDictionary).object(forKey: "purpose") as? String
        
        img_purpose.image = comman.getReaction(reactionName: reaction_name!)
            
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        let post_id = (arrFilteredData[(indexPath.row)] as! NSDictionary).object(forKey: "id") as! Int
        let object_itemDescription = strbrd.instantiateViewController(withIdentifier: "singlePage") as! singlePage
        object_itemDescription.post_id = post_id
       
        self.navigationController?.pushViewController(object_itemDescription, animated: true)
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        
        
        if((self.lastContentOffset > scrollView.contentOffset.y) || scrollView.contentOffset.y <= 0) &&
            self.lastContentOffset < (scrollView.contentSize.height - scrollView.frame.height) {
            
            UIView.animate(withDuration: 0.3) {
                 //self.postButton.frame  = CGRect(x:self.origin.x, y:self.origin.y, width:50,height:50)
                self.postButton.isHidden = false
            }
            
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y
            && scrollView.contentOffset.y > 0)
        {
            UIView.animate(withDuration: 0.3) {
              // self.postButton.frame  = CGRect(x:self.origin.x + 25 ,y:self.origin.y + 25 ,width:0,height:0)
                self.postButton.isHidden = true
            }
            
           
        }
        
        
        self.lastContentOffset = scrollView.contentOffset.y
     
      
    }
    
    
    
}
