//
//  ViewController.swift
//  HelixTask
//
//  Created by G.M on 12.05.21.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK:- Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variables
    
    private var items: [Item] = []
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        getItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK:- Configure View
    
    private func configureView() {
        tableView.registerCells(names: [ItemTableViewCell.id])
        // add loader
    }
    
    //MARK:- Get Data From Api
    
    private func getItems() {
        let dataManager = DataManager.shared
        dataManager.getDataFromAPI() { [weak self] (items) in
            guard let items = items else { return }
            self?.items = items
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    //MARK:- UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.id) as! ItemTableViewCell
        cell.updateInfo(item: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var vc: DetailsViewController!
        
        if #available(iOS 13.0, *) {
            vc = storyboard?.instantiateViewController(identifier: DetailsViewController.id) as? DetailsViewController
        } else {
            vc = storyboard?.instantiateViewController(withIdentifier: DetailsViewController.id) as? DetailsViewController
        }
        
        vc?.item = items[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

