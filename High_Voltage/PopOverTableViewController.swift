//
//  PopOverTableViewController.swift
//  High_Voltage
//
//  Created by Doug Wagner on 3/28/18.
//  Copyright © 2018 Doug Wagner. All rights reserved.
//

import UIKit

protocol HVPopOverDelegate {
    func didSelectThisVariable(varName: String)
}

class PopOverTableViewController: UITableViewController {
    var popOverArray = [String]()
    var delegate: HVTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popOverArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: popOverArray[indexPath.row], for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectThisVariable(varName: popOverArray[indexPath.row])
    }
    
}


