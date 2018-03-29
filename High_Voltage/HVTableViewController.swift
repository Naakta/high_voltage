//
//  HVTableViewController.swift
//  High_Voltage
//
//  Created by Doug Wagner on 3/28/18.
//  Copyright © 2018 Doug Wagner. All rights reserved.
//

import UIKit

class HVTableViewController: UITableViewController, HVPopOverDelegate, UITextFieldDelegate {
    
    var myBrain = HVCalculator()
    var popOverArray = [String]()
    var tableArray = [String]()
    var fullCellString = ""
    var cellString = ""
    var completed = false


    // Prototype Methods
    
    func didSelectThisVariable(varName: String) {
        cellString = varName
        fullCellString = varName + "Cell"
        tableArray.append(fullCellString)
        dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    
    
    // View Stuff
    
    override func viewDidLoad() {
        super.viewDidLoad()
        printShit()
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
        return tableArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let thisCellString = tableArray[indexPath.row]
        let lastCellOfTable = tableArray.count - 1
        let cell = tableView.dequeueReusableCell(withIdentifier: thisCellString, for: indexPath)
        
        if completed {
            let textField = cell.viewWithTag(1001) as! UITextField
            let thisNumber = myBrain.numberDictionary[thisCellString]
            textField.text = "\(thisNumber!)"
        }
        if lastCellOfTable == indexPath.row && !completed {
            let textField = cell.viewWithTag(1001) as! UITextField
            textField.becomeFirstResponder()
        }
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            textField.resignFirstResponder()
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" {
            myBrain.updateThisVariable(string: cellString, with: Double(textField.text!)!)
            if myBrain.readyToEquate() {
                printShit()
                tableArray = myBrain.fillTableArray(array: tableArray)
                completed = true
                myBrain.fillNumberDictionary()
                tableView.reloadData()
            }
            textField.resignFirstResponder()
        }
    }
    
    // MARK:-
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popOver" {
            let controller = segue.destination as! PopOverTableViewController
            controller.delegate = self
            controller.popOverArray = myBrain.fillPopArray()
        }
    }
    
    @IBAction func clearWasPressed() {
        myBrain = HVCalculator()
        tableArray = [String]()
        tableView.reloadData()
        completed = false
    }
    
    func printShit() {
        print(myBrain.myWatts)
        print(myBrain.myVolts)
        print(myBrain.myAmps)
        print(myBrain.myOhms)
    }
    
//    @IBAction func popOverAction(_ sender: Any) {
//        self.performSegue(withIdentifier: "popOver", sender: self)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "popOver" {
//            let controller = segue.destination.popoverPresentationController
//            controller?.delegate = self
//
//        /*let controller = segue.destination as! UIPopoverPresentationController
//        controller.delegate = self*/
//        }
//    }
//    
//    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
//        return .none
//    }
}
