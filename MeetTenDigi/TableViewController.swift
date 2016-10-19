//
//  TableViewController.swift
//  MeetTenDigi
//
//  Created by derek lee bronston on 10/18/16.
//  Copyright © 2016 Bytedissident. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    let refresh = UIRefreshControl()
    var model = TDEventsModel()
    
    lazy var ac = { () -> UIActivityIndicatorView in
        
        let a = UIActivityIndicatorView()
        a.frame = CGRect(x: 100.0, y: 100.0, width: 20.0, height: 20.0)
        a.activityIndicatorViewStyle = .gray
        a.startAnimating()
        
        return a
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Meet Ups"
        
        let options = NSKeyValueObservingOptions([.new, .old])
        model.addObserver(self, forKeyPath: "eventChange", options:options, context: nil)
        model.listEvents()
        
        self.tableView.backgroundView = self.ac()
        
        //REFRESH
        refresh.addTarget(self, action: #selector(TableViewController.refreshEvents), for: .valueChanged)
        self.tableView.addSubview(self.refresh)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.events.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)

        cell.textLabel?.text = self.model.events[indexPath.row].name
        cell.detailTextLabel?.text = self.model.events[indexPath.row].StartTime
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let url = NSURL(string: self.model.events[indexPath.row].EventURL!){
            if UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.open(url as URL, options:[:], completionHandler: nil)
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        self.refresh.endRefreshing()
        self.tableView.backgroundView = nil
        self.tableView.reloadData()
    }
    
    //HANDLE REFRESH
    func refreshEvents(){
        
        self.model.events.removeAll()
        self.tableView.reloadData()
        self.refresh.beginRefreshing()
        model.listEvents()
    }
}
