//
//  DataManager.swift
//  HelixTask
//
//  Created by G.M on 12.05.21.
//

import Foundation
import CoreData

final class DataManager: NSObject {
    
    let networking = NetworkingService.shared
    let host = "https://www.helix.am/temp/json.php"
    
    static let shared = DataManager()
    
    private override init() {
        super.init()
        
    }
    
    func getDataFromAPI(completion: @escaping ([Item]?) -> Void) {
        networking.request(host) { (result) in
            
            switch result {
            case .success(let data):
                let responseString = String(data: data, encoding: .utf8)
                if (responseString != nil) {
                    let jsonData = responseString!.data(using: .utf8)!
                    let decoder = JSONDecoder()
                    let result = try? decoder.decode(ItemData.self, from: jsonData)
                    completion(result?.data)
                }
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    
}
