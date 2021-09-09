//
//  RadioList.swift
//  TuneInRadio
//
//  Created by Vijay Thota on 9/8/21.
//

import Foundation
import UIKit

class CategoriesViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var radiosDetailsList : [Any] = []
    var radioItemURL : String

    init?(coder: NSCoder, url: String) {
        self.radioItemURL = url
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use `init(coder:image:)` to initialize an `ImageViewController` instance.")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Categories"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RadioL")
        
        let urlString = self.radioItemURL + "&render=json"
        let serviceManager = WebServiceManager.sharedInstance
        serviceManager.sendRequest(urlString: urlString, withCompletion: { (data) -> Void in
            if let data = data, let arrayOfRadiosList = data["body"] as? [Any] {
                for obj in arrayOfRadiosList {
                    self.radiosDetailsList.append(obj)
                }
            } else {
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    
}


extension CategoriesViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.radiosDetailsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RadioL", for: indexPath)
        print("Detail object at \(indexPath.row) = \(self.radiosDetailsList[indexPath.row])")
        if let object = self.radiosDetailsList[indexPath.row] as? [String: Any], let key = object["text"] {
            cell.textLabel?.text = "\(key)"
        }
        return cell
    }
}

extension CategoriesViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let object = self.radiosDetailsList[indexPath.row] as? [String: Any], let objectList = object["children"] as? [Any] {
            let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "StationsViewController", creator: { coder -> StationsViewController? in
                StationsViewController(coder: coder, items:objectList)
            })
            self.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
