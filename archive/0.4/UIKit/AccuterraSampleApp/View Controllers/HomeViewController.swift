//
//  HomeViewController.swift
//  AccuterraSampleApp
//
//  Created by Brian Elliott on 3/20/20.
//  Copyright © 2020 NeoTreks, Inc. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private let cellReuseIdentifier: String = "Cell"
    
    var itemsInSections: Array<Array<String>> = [["Creating a Map", "Adding Trails", "Displaying Trail Details", "Adding POIs"],["Controlling the Map", "Interacting with the Map"],["List to Map", "Map to List", "Search Term to Map", "Search Term to List"], ["Difficulty Filter Criteria", "Map Filtering", "Map Bounds Filtering"], ["Custom Trail & POI Styles"]]
    var sections: Array<String> = ["Map Display", "Controls", "Searching", "Filtering", "Customizing"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? BaseViewController {
            viewController.homeNavItem = navigationItem
        }
    }
    
    func setNavBar() {
        self.navigationItem.title = "AccuTerra SDK Samples"
        self.navigationItem.setLeftBarButtonItems(nil, animated: false)
        self.navigationItem.setRightBarButtonItems(nil, animated: false)
        self.navigationItem.titleView = nil
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsInSections[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as UITableViewCell
        let text = self.itemsInSections[indexPath.section][indexPath.row]
        
        cell.textLabel!.text = text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: self.itemsInSections[indexPath.section][indexPath.row], sender: nil)
    }
}
