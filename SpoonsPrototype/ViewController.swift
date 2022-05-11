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
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editItems))
        
        
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spoonCounts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Task", for: indexPath)
        
        let currSpoonCount = spoonCounts[indexPath.row] // Get the spoon count once
        cell.textLabel?.text = String(currSpoonCount) // Cast the int as a string so it can be                                                         used as a label
        taskLists[currSpoonCount] = [String]() // Create a new task list for this category of spoon count
        return cell
    }
    
    // Add new task to the main list
    @objc func addItem() {
        let ac = UIAlertController(title: "Enter new task", message: nil, preferredStyle: .alert)
        ac.addTextField() // User enters answer here
        
        let submitTask = UIAlertAction(title: "Submit", style: .default) { // Trailing closure syntax
        
            
            // Specifies input into closure, use weak so that the closure does not caputure it strongly
            // Avoids strong reference cycle that retains memory for a long time
            [weak self, weak ac] action  in
            guard let newTask = ac?.textFields?[0].text else {return}
            self?.spoonCounts.append(Int(newTask) ?? 0) // FIXME, TEMPORARY NIL COALESCING
            self?.tableView.reloadData()
            
        }
        ac.addAction(submitTask)
        present(ac, animated: true)
        
         
    }
    
    // Handles what to do when the edit button is tapped
    @objc func editItems() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        if tableView.isEditing {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(editItems))
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editItems))
        }
        
        
    }
    
    // Enables deleting in edit mode only
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete && !isEditing {
            spoonCounts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath] , with: UITableView.RowAnimation.automatic )
        }
    }
    
    // Enables swapping in edit mode
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        spoonCounts.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    



}

