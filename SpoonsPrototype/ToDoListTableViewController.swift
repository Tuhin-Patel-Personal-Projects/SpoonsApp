//
//  ToDoListTableViewController.swift
//  SpoonsPrototype
//
//  Created by Tuhin Patel on 5/18/22.
//

import UIKit

class ToDoListTableViewController: UITableViewController {
    var toDoTasks = [String]() // Tasks that have been sent to the to-do list
    var completedTasks = [String]() // Tasks selected by the user that have been completed(CHANGE TO TASKS ARRAY LATER)
    
    var tooDoTasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Let the user remove items
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Mark as done", style: .plain, target: self, action: #selector(allowTaskSelection))
        
        // Make the title To-Do
        self.title = "To-Do"

       
    }

    // One row per task
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoTasks.count
    }
    
    // Create a cell for each task
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItem", for: indexPath)
        
        // Get a task from the array
        //let task = tooDoTasks[indexPath.row] UNCOMMENT
        
        cell.textLabel?.text = toDoTasks[indexPath.row] // Labels are in format of                                                      //"taskName, spoonCount"
        
        // cell.textLabel?.text = "\(task.taskName), \(task.taskSpoonCount)" UNCOMMENT
        
        return cell
    }
    
    // Marks a task as having been selected by the user while marking tasks as done
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // The user should only be allowed to do this if multiple-row selection is active
        if (self.tableView.allowsMultipleSelection) {
            
            // Safely get the current cell
            guard let currCell = self.tableView.cellForRow(at: indexPath) else { return }
            
            // Safely get the text
            guard let cellContents = currCell.textLabel?.text else { return }
            
            // Move the selected item to the array of completed tasks
            completedTasks.append(cellContents)
        }
    }
    
    // Remove a task from the array of completed items if it is deselected
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Safely get the current cell
        guard let currCell = self.tableView.cellForRow(at: indexPath) else { return }
        
        // Safely get the text
        guard let cellContents = currCell.textLabel?.text else { return }
        
        // Safely the index of the item that should be removed, then remove at that index
        guard let index = completedTasks.firstIndex(of: cellContents) else {return}
        completedTasks.remove(at: index)
    }
    
    // When the user presses "Mark as done", they should be allowed to select multiple
    // tasks
    @objc func allowTaskSelection() {
        self.tableView.allowsMultipleSelection = true // Let the user pick multiple rows
        
        // Remove items from the to-do list
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(removeFromList))
    }
    
    // Once the user presses Done, the selected tasks should be removed from the list
    @objc func removeFromList() {
        
        var index: Int // Will keep track of position in the array
        
        // Loop through the user's final selections that are in completedTasks
        for task in completedTasks {
            // Get the index of where task is in toDoTasks
            index = toDoTasks.firstIndex(of: task)! // Will never be nil
            toDoTasks.remove(at: index)
            
            // UNCOMMENT later
            //ooDoTasks.remove(at: index)
        }
        
        // Empty completed tasks now that these items are no longer relevent
        completedTasks.removeAll()
        
        // Don't alllow users to select multiple rows now
        self.tableView.allowsMultipleSelection = false
        
        // Put the "Mark as done" button back and reload the view to show the changes
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Mark as done", style: .plain, target: self, action: #selector(allowTaskSelection))
        self.tableView.reloadData()
    }
   
   
}
