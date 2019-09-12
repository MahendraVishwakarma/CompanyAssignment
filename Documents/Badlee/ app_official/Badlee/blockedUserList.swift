//


import UIKit

class blockedUserList: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var tableview: UITableView!
    var userList = NSMutableArray()
   
    @IBOutlet weak var headerView: UIView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        headerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        headerView.layer.shadowOffset = CGSize(width:0.0, height:1.0)
        headerView.layer.shadowOpacity = 1.0
        headerView.layer.shadowRadius = 1.0
        tableview.tableFooterView = UIView.init(frame: .zero)
        
      
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let lblName = cell.viewWithTag(11) as! UILabel
        let imgProfile = cell.viewWithTag(10) as! UIImageView
        let btnUnblock = cell.viewWithTag(13) as! UIButton
        
        btnUnblock.addTarget(self, action: #selector(unblockUser(sender:)), for: .touchUpInside)
        
        lblName.text = (userList[indexPath.row] as! NSDictionary).object(forKey: "username") as? String ?? " "
        
        let url =  URL.init(string: StaticURLs.base_url + ((userList[indexPath.row] as! NSDictionary).object(forKey: "avatar") as? String ?? ""))
        
        if(url != nil)
        {
            imgProfile.setImageWith(url!, placeholderImage: UIImage.init(named: "user pic 1x"))
        }
        
        
        return cell
    }
    
    @objc func unblockUser(sender:UIButton)
    {
        let cell =  sender.superview?.superview as? UITableViewCell
        if(cell != nil)
        {
            let indexPath = tableview.indexPath(for: cell!)
            let user_id = (userList[indexPath!.row] as! NSDictionary).object(forKey: "user_id") as! String
            comman.showLoader(toView: self)
            web_services.badlee_delete_with_authentication(page_url: "block.php?userid=\(user_id)", username: appDel.loginUserInfo.username!, password:
                
                appDel.loginUserInfo.password!, success: { (data) in
                print(data!)
                self.userList.removeObject(at: indexPath!.row)
                self.tableview.reloadData()
              
                self.showToast(message: "User has been unblocked")
                comman.hideLoader(toView: self)
                
            }) { (error) in
                
                comman.hideLoader(toView: self)
            }
            
        }
       
        
    }
    
   

}
