//
//  TableViewController.swift
//  MeetTenDigi
//
//  Created by derek lee bronston on 10/18/16.
//  Copyright © 2016 Bytedissident. All rights reserved.
//

import UIKit

enum eventState {
    
    case intial
    case loading
    case refreshing
    case success
    case failure
}

class TableViewController: UITableViewController {

    let refresh = UIRefreshControl()
    var model = TDEventsModel()
    var currentState = eventState.intial
    
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
        
        //SET DEFAULT STATE
        self.currentState = eventState.loading
        
        //workaround for XCTEST Bug
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil {
            let options = NSKeyValueObservingOptions([.new, .old])
            model.addObserver(self, forKeyPath: "eventChange", options:options, context: nil)
            model.addObserver(self, forKeyPath: "eventFail", options:options, context: nil)
        }
        model.listEvents()
        
        //ADD SPINNER TO TABLEVIEW ON INITIAL LOAD
        self.tableView.backgroundView = self.ac()
        
        //REFRESH
        refresh.addTarget(self, action: #selector(TableViewController.refreshEvents), for: .valueChanged)
        self.tableView.addSubview(self.refresh)
    }
    
    deinit {
        
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil {
            model.removeObserver(self, forKeyPath: "eventChange")
            model.removeObserver(self, forKeyPath: "eventFail")
        }
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
        
        self.tableView.backgroundView = nil
        
        if keyPath == "eventChange"{
            self.refresh.endRefreshing()
            self.tableView.reloadData()
            self.currentState = eventState.success
        }else if keyPath == "eventFail" {
            self.handleFail()
        }
    }
    
    func handleFail(){
        
        //prevent double presntation of view
        if self.currentState == eventState.failure { return }
        self.currentState = eventState.failure
        
        let alert = UIAlertController(title: "Error", message: "Sorry there was an error getting the events list. Please make sure you have access to the internet and location services on for this app. Thanks!", preferredStyle: UIAlertControllerStyle.alert)
        
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {[weak self] (ac) in
            if let strongSelf = self {
                strongSelf.refresh.endRefreshing()
                strongSelf.currentState = eventState.intial
            }
        }
       
        alert.addAction(cancel)
        // show the alert
        self.present(alert, animated: true, completion:nil)
    }
    
    //HANDLE REFRESH
    func refreshEvents(){
        
        self.currentState = eventState.refreshing
        self.model.events.removeAll()
        self.tableView.reloadData()
        self.refresh.beginRefreshing()
        model.listEvents()
    }
}
