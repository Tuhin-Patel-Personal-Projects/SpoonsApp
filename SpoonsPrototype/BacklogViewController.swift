//
//  BacklogViewController.swift
//  SpoonsPrototype
//  Created by Tuhin Patel on 7/8/22.
/*
    Displays a lits of the user's backlogged tasks. Anytime a user starts a new day with
 tasks still in their to-do list, those tasks will be sent here. Just like the
 TaskViewControllers, users may send these tasks to the to-do list.
 */

import UIKit

class BacklogViewController: UITableViewController {
    
    var backlogItems = [Task]() // Contains tasks that are in the backlog
    
    var selectedTasks = [Task]() // Stores tasks the user selects to send to the to-do list
    
    var selectedTasksSpoons = 0 // Sum of the spoon counts of the tasks in selectedTasks
    
    weak var delegate: CategoryViewController! // Need to use functions/variables in CategoryViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Button to let user select tasks to send to the to-do list
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectTasks))
        
        // Set the title
        self.title = "Backlog"
        
        

    }

    // MARK: - Table view data source

    // How many cells are needed
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return backlogItems.count
    }
    
    // Create a cell for each task
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BacklogItem", for: indexPath)
        
        let task = backlogItems[indexPath.row] // Pull out one task
        cell.textLabel?.text = "\(task.taskName), \(task.taskSpoonCount)" // Display in the format of "name, spoonCount"
        
        return cell
    }

    // When tasks are selected, store them in the selectedTasks array
    // Will mark these as tasks currently selected by the user by storing them in the
    // selectedTasks array
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // The user should only be allowed to do this if multiple-row selection is active
        if (self.tableView.allowsMultipleSelection) {
            
            // Get the selected task once
            let selectedTask = backlogItems[indexPath.row]
            
            // Move the selected item to the array, updated the sum of its spoons
            selectedTasks.append(selectedTask)
            selectedTasksSpoons += selectedTask.taskSpoonCount
            
        }
    }
    
    // Remove a task from the selected tasks array if its row is deselected
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        // Get the task from this row
         let selectedTask = backlogItems[indexPath.row]
        
        // Get the index of where this task is in the selectedTasks array
        let index = selectedTasks.firstIndex(of: selectedTask)!
        
        // Remove the item from selectedTasks, also subtract its spoon count from the total
        selectedTasks.remove(at: index)
        selectedTasksSpoons -= selectedTask.taskSpoonCount
    }
    
    // FUNCTIONS FOR ON-SCREEN BUTTONS
    
    // When the select button is pressed, let the user start selectng tasks to send to the to-do list
    @objc func selectTasks() {
        self.tableView.allowsMultipleSelection = true // Let the user pick multiple rows
        
        // Sumbit items to be sent to the to do list
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitTasks))
        
    }
    
    // Handles the job of taking tasks selected by the user and moving them to the to-do list
    @objc func submitTasks() {
        var index: Int // Stores where the task is listed in the backlogTasks array
        
        // Check if the user surpasse their max spoon coult
        let maxSurpassed = delegate.spoonsOverMax(selectedTasksSpoons)
        
        // If not over the max, go ahead and add all selected items to the to-do lists
        if(!maxSurpassed) {
            
            // Update the usedSpoons variable
            delegate.updateUsedSpoons(selectedTasksSpoons)
            
            for task in selectedTasks {
                delegate.placeInToDo(task)
                
                // Remove from the backlog array, both here and in the CategoryView
                index = backlogItems.firstIndex(of: task)!
                backlogItems.remove(at: index)
                delegate.removeFromBacklog(task)
            }
            
            // Empty selected tasks now that they are gone,the total of its spoon counts is
            // now 0
            selectedTasks.removeAll()
            selectedTasksSpoons = 0
            
            // Disable the ability to select multiple rows
            self.tableView.allowsSelection = false
    
            // Let user have the option to select items again
            navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectTasks))
            self.tableView.reloadData()
        } else { // Notify user they are over their max otherwise
            
            // Create the message
            let ac = UIAlertController(title: "You have went over your max!", message: "Please deselect some tasks", preferredStyle: .alert)
            
            // Create an OK action to dismiss controller
            let okAction = UIAlertAction(title: "OK", style: .cancel) {
                action  in print("OK was tapped")
            }
            
            // Present the message
            ac.addAction(okAction)
            present(ac, animated: true)
        }
            
            
            
        
    }
        
}
