//
//  RadioList.swift
//  TuneInRadio
//
//  Created by Vijay Thota on 9/8/21.
//

import Foundation

public class WebServiceManager : NSObject {
    static let sharedInstance: WebServiceManager = {
        let instance = WebServiceManager()
        // setup code
        return instance
    }()
    
    public func sendRequest(urlString: String, withCompletion completion:@escaping ([String: Any]?) -> Void) {
        // Session Object
        let session = URLSession.shared
        
        // Preparing url object with provided URLString
        let url = URL(string: urlString)
        
        // Preparing the request object
        let request = NSMutableURLRequest(url: url!,
                                  cachePolicy: .useProtocolCachePolicy,
                              timeoutInterval: 10.0)
        
        // Perform data task
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                // if Error
                print("Error = \(String(describing: error))");
            } else { // No Error
                let httpStatus = response as! HTTPURLResponse
                if (httpStatus.statusCode == 200) {
                    guard let data = data else {
                        completion(nil)
                        return
                    }
                    guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                        completion(nil)
                        return
                    }
                    completion(json as? [String : Any])
                } else {
                    completion(nil)
                }
            }
        })
        dataTask.resume()
    }
}

