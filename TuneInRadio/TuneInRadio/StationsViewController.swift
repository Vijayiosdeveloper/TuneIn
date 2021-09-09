//
//  RadioList.swift
//  TuneInRadio
//
//  Created by Vijay Thota on 9/8/21.
//
import Foundation
import UIKit

class StationsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var itemList : [Any] = []

    init?(coder: NSCoder, items: [Any]) {
        self.itemList = items
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use `init(coder:image:)` to initialize an `ImageViewController` instance.")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Stations"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RadioL")
        self.tableView.reloadData()
    }
}


extension StationsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RadioL", for: indexPath)
        print("Detail object at \(indexPath.row) = \(self.itemList[indexPath.row])")
        if let object = self.itemList[indexPath.row] as? [String: Any], let key = object["text"] {
            cell.textLabel?.text = "\(key)"
        }
        return cell
    }
}

extension StationsViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let object = self.itemList[indexPath.row] as? [String: Any] {
            let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "StationViewController", creator: { coder -> StationViewController? in
                StationViewController(coder: coder, item:object)
            })
            self.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
