

import UIKit

class noconnection: UIViewController
{

    @IBOutlet weak var btnConn: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        btnConn.imageView?.image = btnConn.imageView?.image?.withRenderingMode(.alwaysTemplate)
        btnConn.imageView?.tintColor = AppColor.themeColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func btnConn(_ sender: Any)
    {
        
        
       let isNet =  web_services.isConnectedToNetwork()
        if(isNet)
        {
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            self.showToast(message: "No internet connection found")
        }
       
    }
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
   


}
