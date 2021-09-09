//
//  RadioList.swift
//  TuneInRadio
//
//  Created by Vijay Thota on 9/8/21.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items : [Any] = []
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Home"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RadioList")

        let serviceManager = WebServiceManager.sharedInstance
        let urlStr = "http://opml.radiotime.com/?partnerId=9xRsEvDb&render=json"
        serviceManager.sendRequest(urlString: urlStr, withCompletion: { (data) -> Void in
                        
            if let data = data, let arrayOfRadiosList = data["body"] as? [Any] {
                for obj in arrayOfRadiosList {
                    self.items.append(obj)
                }
            } else {
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
}

extension ViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RadioList", for: indexPath)
        print("Radio list object at \(indexPath.row) = \(self.items[indexPath.row])")
        if let object = self.items[indexPath.row] as? [String: Any], let key = object["text"] {
            cell.textLabel?.text = "\(key)"
        }
        return cell
    }
}

extension ViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let object = self.items[indexPath.row] as? [String: Any], let url = object["URL"] {
            let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "GenreViewController", creator: { coder -> GenreViewController? in
                GenreViewController(coder: coder, url: url as! String)
            })
            self.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
