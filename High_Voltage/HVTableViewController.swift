//
//  HVTableViewController.swift
//  High_Voltage
//
//  Created by Doug Wagner on 3/28/18.
//  Copyright © 2018 Doug Wagner. All rights reserved.
//

import UIKit

class HVTableViewController: UITableViewController, HVPopOverDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {
    
    var myBrain = HVCalculator()
    var popOverArray = [String]()
    var tableArray = [String]()
    var cellString = ""
    var completed = false

    @IBOutlet weak var plusButton: UIBarButtonItem!
    
    // Prototype Methods
    
    func didSelectThisVariable(varName: String) {
        // Takes the string selected from popover, tracks it for use in textFieldDidEndEditing
        cellString = varName
        tableArray.append(varName + "Cell")
        dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    
    
    // View Stuff
    
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
        return tableArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch cell identifier from tableArray, find index of the last cell currently in the table
        // and create the cell
        let thisCellString = tableArray[indexPath.row]
        let lastCellOfTable = tableArray.count - 1
        let cell = tableView.dequeueReusableCell(withIdentifier: thisCellString, for: indexPath)
        
        // Fetches the textField in the cell
        if let textField = cell.viewWithTag(1001) as? UITextField
        {
            // if the solution completed and all 4 cells are in the table, disable textFields and + button
            if tableArray.count >= 4 {
                textField.isEnabled = false
                plusButton.isEnabled = false
            } else { // else, keep them enabled
                textField.isEnabled = true
                plusButton.isEnabled = true
            }
            
            // Gives the textField firstResponder so keyboard pops up for user
            textField.becomeFirstResponder()

            // if textFieldDidEndEditing executed myBrain.readytoEquate() then completed will be true
            // and this will only run 4 times for the repopulating of the 4 textFields
            if completed {
                // each number will be pulled from the dictionary created upon myBrain.readytoEquate()
                // and will repopulate the textFields with the value
                let thisNumber = myBrain.numberDictionary[thisCellString]
                textField.text = "\(thisNumber!)"
            }
            
            // Needed for after hitting clear - the reused textField kept the data from initial instantiation
            // Can only run for the last cell on the table or else it will clear previously input numbers
            if lastCellOfTable == indexPath.row && !completed {
                textField.text = ""
            }
        }
        
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // After the user has entered a number, the brain will update that variable
        // which variable was grabbed from popover, and the number is taken from the textField
        if textField.text != "" {
            myBrain.updateThisVariable(string: cellString, with: Double(textField.text!)!)
            // This will run once two variables have been set in the brain
            if myBrain.readyToEquate() {
                // brain fills in the last two variables so the order of the current cells isn't disturbed
                tableArray = myBrain.fillTableArray(array: tableArray)
                completed = true
                myBrain.fillNumberDictionary()
                tableView.reloadData()
            }
            textField.resignFirstResponder()
            return true
        }
        return false
    }
    
    
    // MARK:-
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popOver" {
            let controller = segue.destination as! PopOverTableViewController
            // Sends over an array based on which variables are filled in the brain
            controller.popOverArray = myBrain.fillPopArray()
            // Needed so we can grab which variable is chosen by user
            controller.delegate = self
            // Needed for popover (similar to hooking up text Field
            controller.popoverPresentationController?.delegate = self
            // Sets up the height of the popover based on size of popOverArray
            controller.preferredContentSize = CGSize(width: 125, height: 44 * controller.popOverArray.count)
        }
    }
    
    @IBAction func clearWasPressed() {
        myBrain = HVCalculator()
        completed = false
        tableArray = [String]()
        plusButton.isEnabled = true
        tableView.reloadData()
    }
    
    // Needed for popover
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}
