
import UIKit
import CropViewController



class imageOrientationVC: UIViewController,CropViewControllerDelegate,UIScrollViewDelegate {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var viewWidthCons: NSLayoutConstraint!
    @IBOutlet weak var imgPOst: UIImageView!
    var standardWidth:CGFloat!
    @IBOutlet weak var cropperView: BABCropperView!
    var selected_imagename:String!
    var img_selected:UIImage!
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    var post_type = ""
    @IBOutlet weak var portraitView: UIView!
    @IBOutlet weak var landscapeView: UIView!
    var homeObject:AnyObject!
    @IBOutlet weak var btnLandscape: UIButton!
    
    @IBOutlet weak var btnPortrait: UIButton!
    
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        standardWidth = UIScreen.main.bounds.size.width
        
        headerView.layer.shadowOffset = CGSize(width:0.0, height:1.0)
        headerView.layer.shadowOpacity = 1.0
        headerView.layer.shadowRadius = 1
        headerView.layer.masksToBounds = false
        
        landscapeView.layer.cornerRadius = 25
        portraitView.layer.cornerRadius = 25
        
        cropperView.cropsImageToCircle = false
        imgPOst.image = img_selected
        cropperView.image = img_selected
        
        cropperView.isHidden = false
        imgPOst.isHidden = true
    
        self.btnPortrait(self)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func btnNext(_ sender: Any)
    {
        
        cropperView.renderCroppedImage { (croppedImage, rect) in
            
            if(croppedImage != nil)
            {
                let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
                let object_postitem = strbrd.instantiateViewController(withIdentifier: "post_item") as! post_item
                object_postitem.selected_imagename = self.selected_imagename
                object_postitem.img_selected = croppedImage
                object_postitem.parentObject = self
                object_postitem.isTitle = false
                object_postitem.post_type = self.post_type
                object_postitem.homeObject = self.homeObject
                object_postitem.imgHeight = self.mainViewHeight.constant
                self.navigationController?.pushViewController(object_postitem, animated: true)
            }
            else
            {
                comman.showAlert("Badlee", "something went wrong", self)
            }
            
            
        }
        
    }
    
    @IBAction func btnPortrait(_ sender: Any)
    {
        viewWidthCons.constant = UIScreen.main.bounds.width*1
        mainViewHeight.constant = UIScreen.main.bounds.width*1
        // let heighttt = CGFloat(standardWidth*1.4)
        //let hh = String(format: "%.2f", standardWidth*1.4)
        
        post_type = "portrait"
        
        let heighttt  = mainViewHeight.constant*1.14 //Int(standardWidth*1.4)
        
        cropperView.cropSize = CGSize(width:UIScreen.main.bounds.size.width,height:CGFloat(heighttt))
        btnPortrait.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        btnLandscape.backgroundColor = .clear
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
            self.view.updateConstraints()
          
        }
        
    }
    @IBAction func btnLandscap(_ sender: Any)
    {
        
        post_type = "landscape"
        viewWidthCons.constant = UIScreen.main.bounds.width*1
        mainViewHeight.constant = UIScreen.main.bounds.width*0.75
        
        let heighttt  = mainViewHeight.constant
        cropperView.cropSize = CGSize(width:UIScreen.main.bounds.size.width,height:heighttt)
        
        btnLandscape.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        btnPortrait.backgroundColor = .clear
        
        UIView.animate(withDuration: 0.4)
        {
            self.view.layoutIfNeeded()
            self.view.updateConstraints()
           
        }
        
    }
    
    
    @IBAction func btnCrop(_ sender: Any)
    {
       
    }
   
}
