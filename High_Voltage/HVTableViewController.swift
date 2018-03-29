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

    @IBOutlet weak var plusButton: UIBarButtonItem!
    
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
        
        let textField = cell.viewWithTag(1001) as! UITextField
        textField.becomeFirstResponder()
        
        if textField.isFirstResponder{
            print("--------I'm a firefighter")
        } else {
            print("--------I'm a dumptruck")
        }
        
        if completed {
            let thisNumber = myBrain.numberDictionary[thisCellString]
            textField.text = "\(thisNumber!)"
            textField.resignFirstResponder()
            print("completed!!!")
        }
        if lastCellOfTable == indexPath.row && !completed {
            textField.text = ""
            print("responding!")
        }
        
        if tableArray.count == 4 {
            plusButton.isEnabled = false
        } else {
            plusButton.isEnabled = true
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
                tableArray = myBrain.fillTableArray(array: tableArray)
                completed = true
                myBrain.fillNumberDictionary()
                tableView.reloadData()
                print("I'm ready!")
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
        clearTextFields()
        tableView.reloadData()
        completed = false
        plusButton.isEnabled = true
    }
    
    func clearTextFields() {
        
    }
}
