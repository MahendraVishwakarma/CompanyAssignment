
import UIKit

class interestedIN: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var arrItems:NSArray!

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        headerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        headerView.layer.shadowOffset = CGSize(width:0.0, height:1.0)
        headerView.layer.shadowOpacity = 1.0
        headerView.layer.shadowRadius = 1
        headerView.layer.masksToBounds = false
        
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func btnBacl(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let lblName = cell.viewWithTag(11) as! UILabel
        let imgProfile = cell.viewWithTag(12) as! UIImageView
        let info = comman.getInterestInfo(id: arrItems[indexPath.row] as! String)
        let url = URL.init(string: info.object(forKey: "icon") as? String ?? "")
        
        if(url != nil)
        {
            imgProfile.setImageWith(url!, placeholderImage: UIImage.init(named: ""))
        }
        lblName.text = info.object(forKey: "name") as? String ?? ""
        
        return cell
    }

}
