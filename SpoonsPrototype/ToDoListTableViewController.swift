//
//  ToDoListTableViewController.swift
//  SpoonsPrototype
//
//  Created by Tuhin Patel on 5/18/22.
//

import UIKit

class ToDoListTableViewController: UITableViewController {
    var toDoTasks = [Task]() // Tasks that have been sent to the to-do list
    var completedTasks = [Task]() // Tasks selected by the user that have been completed(CHANGE TO TASKS ARRAY LATER)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Let the user remove items
        let checkOffButton =  UIBarButtonItem(title: "Check off", style: .plain, target: self, action: #selector(allowTaskSelection))
        
        toolbarItems = [checkOffButton]
        
        
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Options", style: .plain, target: self, action: #selector(showOptions))
        
                
        // Let user move items back to their orignal categories
        
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
        

        let task = toDoTasks[indexPath.row]
        cell.textLabel?.text = "\(task.taskName), \(task.taskSpoonCount)" // Display in the format of "name, spoonCount"
        
        return cell
    }
    
    // Marks a task as having been selected by the user while marking tasks as done
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // The user should only be allowed to do this if multiple-row selection is active
        if (self.tableView.allowsMultipleSelection) {
          
            // Move the selected item to the array of completed tasks
            completedTasks.append(toDoTasks[indexPath.row])
        }
    }
    
    // Remove a task from the array of completed items if it is deselected
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Remove this task from the array of completed tasks
        completedTasks.remove(at: indexPath.row)
    }
    
    
    // FUNCTIONS FOR ON-SCREEN BUTTONS
    
    
    // Shows the user the options they have on this screen
    @objc func showOptions() {
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    // When the user presses "Check off, they should be allowed to select multiple
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
            
            
        }
        
        // Empty completed tasks now that these items are no longer relevent
        completedTasks.removeAll()
        
        // Don't alllow users to select multiple rows now
        self.tableView.allowsMultipleSelection = false
        
        // Put the "Mark as done" button back and reload the view to show the changes
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Check off", style: .plain, target: self, action: #selector(allowTaskSelection))
        self.tableView.reloadData()
        
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    
   
    
   
}
