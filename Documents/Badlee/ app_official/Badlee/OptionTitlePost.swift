//

//

import UIKit

class OptionTitlePost: UIViewController {

    var locationobj:location!
    var community:communityVC!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        alertView.layer.cornerRadius = 15
        alertView.layer.masksToBounds = true
        
    }
    
    @IBOutlet weak var alertView: UIView!
    
    @IBAction func btnImagePOST(_ sender: Any) {
        
//        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
//
//        let navigationVC = (strbrd.instantiateViewController(withIdentifier: "CameraViewController") as! navigationcontroller)
//        let cameraObject = navigationVC.visibleViewController as! CameraViewController
//        cameraObject.selected_imagename = "shout profile pic 1x"
//        cameraObject.homeObject = homeObject
//        self.dismiss(animated: false, completion: nil)
//        homeObject.present(navigationVC, animated: true, completion: nil)
        
        self.dismiss(animated: false, completion: nil)
        if(community != nil){
            community.floatingActions(actiontype: "shout")
        }else if(locationobj != nil){
            locationobj.floatingActions(actiontype: "shout")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let tappedView = touches.first?.view
        if(tappedView?.tag != 10){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
   
    
    @IBAction func btnTitlePost(_ sender: Any) {
        let strbrd = UIStoryboard.init(name: "comman", bundle: nil)
        let object_postitem = strbrd.instantiateViewController(withIdentifier: "post_item") as! post_item
        object_postitem.selected_imagename = "shout profile pic 1x"
        //object_postitem.img_selected = croppedImage
        //object_postitem.parentObject = nil
        object_postitem.isTitle = true
        object_postitem.post_type = ""
        let object = community != nil ? community : locationobj
        object_postitem.homeObject = object
        object_postitem.imgHeight = 0
        self.dismiss(animated: false, completion: nil)
        object?.navigationController?.pushViewController(object_postitem, animated: true)
        
    }
    
}
