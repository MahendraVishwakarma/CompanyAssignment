//

//

import UIKit
import CoreLocation
import MBProgressHUD

class post_item: UIViewController,UITextViewDelegate,shareDataDelagate,TrendingProductsCustomDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate
{
    

    @IBOutlet weak var heightImage: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var img_itemtype: UIImageView!
    @IBOutlet weak var taken_image: UIImageView!
    var selected_imagename:String!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var btnCity: UIButton!
   // var placeHolderDescription = "Write a Description"
    //var placeHolderTitle = "What do you need?"
    var isTitle:Bool?
    @IBOutlet weak var btnpost: UIButton!
    @IBOutlet weak var txtTitle: UITextView!
    var cityID = "0"
     var category = ""
    var media_url = ""
    var mediaTitleKey = ""
    var mediaContent = ""
    var purpose_id = "0"
    var imr_error = ""
    @IBOutlet weak var lblChar: UILabel!
    var post_type: String!
    
    var parentObject:imageOrientationVC!
    var imgHeight:CGFloat!
    var img_selected:UIImage!
    var lat:Double = 0.0
    var long:Double = 0.0
    var isImageFine = false
    var homeObject:Any!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        headerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        headerView.layer.shadowOffset = CGSize(width:0.0, height:1.0)
        headerView.layer.shadowOpacity = 1.0
        headerView.layer.shadowRadius = 1
        headerView.layer.masksToBounds = false
        
        
        txtTitle.layer.borderColor = UIColor.lightGray.cgColor
        txtTitle.layer.borderWidth = 0.6
        txtTitle.layer.cornerRadius = 8
        txtTitle.layer.masksToBounds = true
        txtTitle.textColor = .black
        txtTitle.placeholder = "What do you need?"
        
        txtDescription.layer.borderColor = UIColor.lightGray.cgColor
        txtDescription.layer.borderWidth = 0.6
        txtDescription.layer.cornerRadius = 8
        txtDescription.layer.masksToBounds = true
        txtDescription.textColor = .black
        txtDescription.placeholder = "Write a Description"
        
        
        if(isTitle == true){
            taken_image.isHidden = true
            txtTitle.isHidden = false
           // btnPostingType.isHidden = true
            lblChar.isHidden = false
            mediaTitleKey = "title"
            btnPostingType.setImage(nil, for: .normal)
            btnPostingType.isEnabled = false
            
        }else{
            taken_image.isHidden = false
            txtTitle.isHidden = true
            lblChar.isHidden = true
            btnPostingType.isHidden = false
            mediaTitleKey = "media"
            taken_image.image = img_selected
            self.getImage_url(uploading_image: img_selected)
        }
        
        
        self.setpostingtype()
        
        //heightImage.constant = imgHeight
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(navigationVC.sharedInstance.lat!, navigationVC.sharedInstance.long!)
        lat = coordinate.latitude
        long = coordinate.longitude
        
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func btnBAck(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
       
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func btnCategory(_ sender: Any)
    {
        self.view.endEditing(true)
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        let object = strbrd.instantiateViewController(withIdentifier: "interested_catogories") as! interested_catogories
        object.modalPresentationStyle = .custom
        object.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        object.customDelegateForDataReturn = self
        object.isFrom = "search"
        object.selected_row = NSMutableArray()
        
        let arr = category.components(separatedBy: ",")
        
        var arr_int = Array<Any>()
        
        for  item in arr
        {
            let ids = Int(item)
            if(ids != nil)
            {
                 arr_int.append(ids!)
            }
           
        }
        
        object.selected_row.addObjects(from: arr_int)
        self.present(object, animated: true, completion: nil)
        
    }
    @IBAction func btnCity(_ sender: Any)
    {
          self.view.endEditing(true)
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        let object = strbrd.instantiateViewController(withIdentifier: "citiesVC") as! citiesVC
        object.shareDataDelegate = self
        object.selected_city_id = cityID
        object.modalPresentationStyle = .custom
        object.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        
        object.modalPresentationStyle = .overCurrentContext
        object.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.present(object, animated: true, completion: nil)
    }
    func sendData(data: String?, city_id: String?)
    {
        btnCity.setTitle(data, for: .normal)
        cityID = city_id!
        btnCity.isSelected = true
       
    }
    func sendDataBackToHomePageViewController(data: String?, data2:String)
    {
        btnCategory.setTitle(data, for: .normal)
        category = data2
        btnCategory.isSelected = true
        
        
    }
    @IBAction func btnpostItem(_ sender: Any)
    {
       // let device_id = UIDevice.current.identifierForVendor?.uuidString
        self.view.endEditing(true)
        
        if(isTitle == true){
            
            mediaContent = txtTitle.text
            if(Int(txtTitle.text.count) <= 0)
            {
                self.showToast(message: "Please give title about the post")
                return
            }
        }else{
            mediaContent = media_url
            if(Int(media_url.count) <= 3 || !isImageFine)
            {
                self.showToast(message: "Image should be less than 500kb")
                return
            }
        }
        
        if(Int(txtDescription.text.count) <= 0)
        {
            self.showToast(message: "Please give description about the post")
            return
        }
        
        if(Int(cityID.count) <= 0)
        {
            self.showToast(message: "Please select city")
            return
        }
        
        if(Int(category.count) <= 0)
        {
            self.showToast(message: "Please select category")
            return
        }
        
        
        
        
        let ip = comman.getIFAddresses()
        
        let param = ["ip":ip.last!, "description":txtDescription.text!,"location":cityID,"purpose":purpose_id,"category":category,"\(mediaTitleKey)":mediaContent,"application_id":app_id,"application_secret":app_secret_key,"lat":lat,"long":long,"orientation":post_type!] as [String : Any]
        
        comman.showLoader(toView: self)
        
        web_services.badlee_postitem_with_param(param: param as NSDictionary, page_url: "posts.php", username: appDel.loginUserInfo.username!, password: appDel.loginUserInfo.password!, succuss: { (data) in
            
            comman.hideLoader(toView: self)
            //self.parentObject.dismiss(animated: true, completion: nil)
           
            if(self.homeObject is location){
                
               (self.homeObject as? location)?.refreshedData()
            }else{
                (self.homeObject as? communityVC)?.refreshedData()
            }
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.popToRootViewController(animated: true)
            
            
        }) { (error) in
            
            self.showToast(message: "Please try again")
            print(error ?? "")
            comman.hideLoader(toView: self)
        }
        
    }
    
    func getImage_url(uploading_image:UIImage)
    {
        
        
        DispatchQueue.main.async {
            let obj =  MBProgressHUD.showAdded(to: self.view, animated: true)
            obj.detailsLabel.text = "compressing image"
            let compression = ImageCompression()
            let imageToUpload = compression.imageCompression(image: uploading_image)
            MBProgressHUD.hide(for: self.view, animated: true)
            self.isImageFine = imageToUpload.1
            
            if(!imageToUpload.1){
                
                self.showToast(message: "Image should be less than 500kb")
               
                return
            }
            
            comman.showLoader(toView: self)
            web_services.upload_image(page_url: "media.php", uploading_image: imageToUpload.0, username: appDel.loginUserInfo.username, password: appDel.loginUserInfo.password, success: { (data) in
                
                comman.hideLoader(toView: self)
                
                if((data as! NSDictionary).object(forKey: "code") != nil)
                {
                    self.showToast(message: (data as! NSDictionary).object(forKey: "error") as! String)
                    self.imr_error =  (data as! NSDictionary).object(forKey: "error") as! String
                }
                else
                {
                    self.media_url = (data as! NSDictionary).object(forKey: "url") as! String
                }
                
                print(data ?? "no value")
                
            }) { (error) in
                
                comman.hideLoader(toView: self)
                
            }
            
        }
       
    }
    
    
    @IBAction func btnCamera(_ sender: Any)
    {
         let pickerController = UIImagePickerController()
        
        let optionMenu = UIAlertController(title: nil, message: "Choose resource to take photo", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
            {
                pickerController.delegate = self
                pickerController.sourceType = UIImagePickerControllerSourceType.camera
                pickerController.allowsEditing = true
                self.present(pickerController, animated: true, completion: nil)
            }
            
        })
        
        
        let gallery = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                pickerController.delegate = self
                pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                pickerController.allowsEditing = true
                self.present(pickerController, animated: true, completion: nil)
            }
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
            
        })
        
        
        optionMenu.addAction(camera)
        optionMenu.addAction(gallery)
        optionMenu.addAction(cancel)
        
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
           img_selected = info[UIImagePickerControllerEditedImage] as? UIImage
           taken_image.image = img_selected
           self.getImage_url(uploading_image: img_selected)
           dismiss(animated:true, completion: nil)
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated:true, completion: nil)
    }
    @IBOutlet weak var btnPostingType: UIButton!
    
    @IBAction func btnPostingType(_ sender: Any)
    {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose posting type", preferredStyle: .actionSheet)
        
        let typeLB = UIAlertAction(title: "Lend", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
             self.selected_imagename = "lendandborrow prof pic 1x"
             self.setpostingtype()
        })
        
        
        let typeShout = UIAlertAction(title: "Borrow", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
           self.selected_imagename = "shout profile pic 1x"
           self.setpostingtype()
            
        })
        let typeShowOff = UIAlertAction(title: "Show Off", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.selected_imagename = "show off 1x"
            self.setpostingtype()
        })
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
            
        })
        
        
        optionMenu.addAction(typeLB)
        optionMenu.addAction(typeShout)
        optionMenu.addAction(typeShowOff)
        optionMenu.addAction(cancel)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func setpostingtype()
    {
         img_itemtype.image = UIImage.init(named: selected_imagename)
        
        if(selected_imagename == "lendandborrow prof pic 1x")
        {
            btnpost.backgroundColor = UIColor.init(red: 131.0/255.0, green: 189.0/255.0, blue: 68.0/255.0, alpha: 1)
            btnpost.setTitle("POST FOR LEND", for: .normal)
            btnPostingType.setTitle("POSTING FOR LEND", for: .normal)
            btnpost.setTitleColor(UIColor.white, for: .normal)
            purpose_id = "1"
        }
        else if(selected_imagename == "shout profile pic 1x")
        {
            btnpost.backgroundColor = UIColor.init(red: 53.0/255.0, green: 121.0/255.0, blue: 219.0/255.0, alpha: 1)
            btnpost.setTitleColor(UIColor.white, for: .normal)
            btnpost.setTitle("POST FOR BORROW", for: .normal)
            btnPostingType.setTitle("POSTING FOR BORROW", for: .normal)
            purpose_id = "3"
        }
        else if(selected_imagename == "show off 1x")
        {
            btnpost.backgroundColor = UIColor.init(red: 233.0/255.0, green: 218.0/255.0, blue: 14.0/255.0, alpha: 1)
            btnpost.setTitle("POST FOR SHOW OFF", for: .normal)
            btnpost.setTitleColor(UIColor.black, for: .normal)
            btnPostingType.setTitle("POSTING FOR SHOW OFF", for: .normal)
            purpose_id = "2"
            
        }
    }
    
    
}
