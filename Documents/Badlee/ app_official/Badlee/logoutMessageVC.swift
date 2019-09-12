//


import UIKit

class logoutMessageVC: UIViewController
{

    @IBOutlet weak var img: UIImageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        img.image = UIImage.gifImageWithName("logout")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Timer.scheduledTimer(withTimeInterval: 2.2, repeats: false) { (tmr) in
            exit(0)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
   

}
