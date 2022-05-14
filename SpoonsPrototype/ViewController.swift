//
//  ViewController.swift
//  Spoon Task Manager App
//
//  Created by Tuhin Patel on 5/6/22.
//

import UIKit

class ViewController: UITableViewController {
    
    var spoonCounts = [Int]() // Array containing just the categories of spoon counts the user gives
    
    var taskLists = [Int: [String]]() // Each spoon count assigned to a list of tasks that have that spoon                                  count
    
    var spoonVCs = [Int: TaskViewController]() // Associate a view controller with each spoon count
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create add and edit buttons in the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editItems))
        
        
    }
    

    // Generate the table rows, equal to number of spoon categories
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spoonCounts.count
    }
    
    // Create the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Make a Category cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)
        
        let currSpoonCount = spoonCounts[indexPath.row] // Get the spoon count once
        cell.textLabel?.text = String(currSpoonCount) // Cast the int as a string so it can be                                                         used as a label
        
        taskLists[currSpoonCount] = [String]() // Create a new task list for this category of spoon count
        
        // Create a view controller associated with this spoon count
        if let vc = storyboard?.instantiateViewController(withIdentifier: "TaskList") as? TaskViewController {
            // Set title to be the spoon count
            vc.listName = String(currSpoonCount)
            
            // Add to the dicitonary of View controllers
            spoonVCs[currSpoonCount] = vc
            
        }
        return cell
    }
    
    // Open the view for a specific task list
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Safely get the current cell
        guard let currCell = self.tableView.cellForRow(at: indexPath) else { return }
        
        // Get the cell's spoon count(it will always be the text)
        let rowSpoonCount = Int((currCell.textLabel?.text)!) ?? 0 // Nil coalescing to get the number
        
        // Open the view controller at this area and present it
        navigationController?.pushViewController(spoonVCs[rowSpoonCount]!, animated: true)
        
    }
    
    // Add new task to the main list
    @objc func addItem() {
        // Prompt the user
        let ac = UIAlertController(title: "Enter a spoon count", message: nil, preferredStyle: .alert)
        ac.addTextField() // Give space for the answer
        
        // Processes when the user hits submit
        let submitTask = UIAlertAction(title: "Submit", style: .default) { // Trailing closure syntax
        
            
            // Specifies input into closure, use weak so that the closure does not caputure it strongly
            // Avoids strong reference cycle that retains memory for a long time
            [weak self, weak ac] action  in
            guard let newTask = ac?.textFields?[0].text else {return} // Safely get the answer
            self?.spoonCounts.append(Int(newTask) ?? 0) // FIXME, TEMPORARY NIL COALESCING
                                                        // Add this to the array
            self?.tableView.reloadData() // Reload the table view to show the user the change
            
        }
        
        // Add the submit button and present the whole alert controller
        ac.addAction(submitTask)
        present(ac, animated: true)
        
         
    }
    
    // Handles what to do when the edit button is tapped
    @objc func editItems() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        // If in edit mode, show a done button
        if tableView.isEditing {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(editItems))
        } else { // Otherwise present the edit button
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editItems))
        }
        
        
    }
    
    // Enables deleting in edit mode only
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete && !isEditing {
            spoonCounts.remove(at: indexPath.row) // Delete the item in the array
            tableView.deleteRows(at: [indexPath] , with: UITableView.RowAnimation.automatic ) // Delete the row
        }
    }
    
    // Enables swapping in edit mode
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        spoonCounts.swapAt(sourceIndexPath.row, destinationIndexPath.row) // Swap positions in the array
    }
    
    



}

