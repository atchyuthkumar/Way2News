//
//  SettingsViewController.swift
//  Way2News
//
//  Created by Smscountry on 14/03/21.
//

import UIKit
import WebKit

class SettingsViewController: UIViewController {
   
    //Outlet Connections
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet var webView: WKWebView!
    
    // Variable definitions
    var setArray = ["imperial", "metric"]
    var sctionsArray = ["FAQ", "Units"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // Dismiss the webView
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.webView.removeFromSuperview()
    }
    
}



//MARK:- UITableViewDataSource, UITableViewDelegate
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? UITableViewCell {
            if (indexPath.section == 0) {
                cell.textLabel?.text = "Help"
            } else {
                cell.textLabel?.text = setArray[indexPath.row]
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.settingsTableView.frame.size.width, height: 30))
        let titleLabel = UILabel(frame: view.frame)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.text = sctionsArray[section]
        view.addSubview(titleLabel)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
            self.webView.center = self.view.center
            self.view.addSubview(webView)
            // I have tried with one sample url URL, working fine. I have given sample frame, just uncomment below line
            let url = URL(string: "your URL")
            //webView.load(URLRequest(url: url))
        }
    }
    
    
}
