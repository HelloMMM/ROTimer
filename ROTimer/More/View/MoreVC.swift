//
//  MoreVC.swift
//  ROTimer
//
//  Created by Miles on 2020/12/10.
//

import UIKit

class MoreVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 1:
            let urlString =  "itms-apps:itunes.apple.com/us/app/apple-store/id1543162928?mt=8&action=write-review"
            let url = URL(string: urlString)!
            UIApplication.shared.open(url, completionHandler: nil)
        default:
            break
        }
    }
}
