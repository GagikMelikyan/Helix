//
//  ViewController.swift
//  HelixTask
//
//  Created by G.M on 12.05.21.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataManager = DataManager.shared
        dataManager.getDataFromAPI() { [weak self] (items) in
            
            guard let items = items else { return }
            print(items.count)
//            self?.items = items
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//            }
        }
    }


}

