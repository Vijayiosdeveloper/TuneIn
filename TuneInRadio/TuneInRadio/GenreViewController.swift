//
//  RadioList.swift
//  TuneInRadio
//
//  Created by Vijay Thota on 9/8/21.
//

import Foundation
import UIKit

class GenreViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    var radiosList : [Any] = []
    var radioURL : String
    @IBOutlet weak var tableView: UITableView!
    
    init?(coder: NSCoder, url: String) {
        self.radioURL = url
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use `init(coder:image:)` to initialize an `ImageViewController` instance.")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Genre"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RadioL")
        
        let urlString = self.radioURL + "&render=json"
        let serviceManager = WebServiceManager.sharedInstance
        serviceManager.sendRequest(urlString: urlString, withCompletion: { (data) -> Void in
            if let data = data, let arrayOfRadiosList = data["body"] as? [Any] {
                for obj in arrayOfRadiosList {
                    self.radiosList.append(obj)
                }
            } else {
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
}

extension GenreViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.radiosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RadioL", for: indexPath)
        print("Radio list object at \(indexPath.row) = \(self.radiosList[indexPath.row])")
        if let object = self.radiosList[indexPath.row] as? [String: Any], let key = object["text"] {
            cell.textLabel?.text = "\(key)"
        }
        return cell
    }
}

extension GenreViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let object = self.radiosList[indexPath.row] as? [String: Any], let url = object["URL"] {
            let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "CategoriesViewController", creator: { coder -> CategoriesViewController? in
                CategoriesViewController(coder: coder, url: url as! String)
            })
            self.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
