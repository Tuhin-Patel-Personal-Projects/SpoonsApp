//
//  ToDoListTableViewController.swift
//  SpoonsPrototype
//
//  Created by Tuhin Patel on 5/18/22.
//

import UIKit

class ToDoListTableViewController: UITableViewController {
    var toDoTasks = [Task]() // Tasks that have been sent to the to-do list
    var completedTasks = [Task]() // Tasks selected by the user that have been completed
    var tasksToSendBack = [Task]() // Tasks selected by user to send back to their TaskList
    
    var checkOffOn = false // Represents if the user is currently checking off tasks
    var sendBackOn = false // Represents if the user is currently sending tasks back to their
                          // oriignal lists
    
    weak var delegate: CategoryViewController! // Need to use functions/variables in CategoryViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Lets user select tasks to check off the to-do list
        let checkOffButton =  UIBarButtonItem(title: "Check Off", style: .plain, target: self, action: #selector(allowCheckOff))
        
        // Lets user select tasks to send back to their original to-do list
        //let sendBackButoon =  UIBarButtonItem(title: "Send Back", style: .plain, target: self, action: #selector(allowSendBack)) 
        
        // Set the toolbar
        toolbarItems = [checkOffButton]
        
        // Will open up the toolbar to show user their options.
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Options", style: .plain, target: self, action: #selector(showOptions))
        
                
        
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
        
        if (checkOffOn) { // If in check-off mode, send task to completedTasks array
            completedTasks.append(toDoTasks[indexPath.row])
        } else if(sendBackOn) { // If in send back mode
            tasksToSendBack.append(toDoTasks[indexPath.row])
        }
    
    }
    
    // Remove a task from the array of completed items if it is deselected
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if (checkOffOn) { // If in check-off mode, remove task from completedTasks array
            completedTasks.remove(at: indexPath.row)
        } else if(sendBackOn) { // If in send back mode, remove from send back arrau
            tasksToSendBack.remove(at: indexPath.row)
        }
    }
    
    
    // FUNCTIONS FOR ON-SCREEN BUTTONS
    
    
    // Shows the user the options they have on this screen when pressing "Options"
    @objc func showOptions() {
        navigationController?.setToolbarHidden(false, animated: true) // Show the toolbar
        
        // Let user have the option to close the toolbar
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Hide Options", style: .plain, target: self, action: #selector(hideOptions))
    }
    
    // Hide the user's options when "Hide options" is pressed
    @objc func hideOptions() {
        navigationController?.setToolbarHidden(true, animated: true) // Hide toolbar
        
        // Let the user be able to open the toolbar again.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Options", style: .plain, target: self, action: #selector(showOptions))
    }
    
    // When the user presses "Check off, they should be allowed to select multiple
    // tasks
    @objc func allowCheckOff() {
        self.tableView.allowsMultipleSelection = true // Let the user pick multiple rows
        
        checkOffOn = true // In check-off mode
        
        // Remove items from the to-do list
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(removeFromList))
    }
    
    // Once the user presses "Done," the selected tasks should be removed from the list
    @objc func removeFromList() {
        
        var index: Int // Will keep track of position in the main array
        
        // Loop through the user's final selections that are in completedTasks
        for task in completedTasks {
            // Get the index of where task is in toDoTasks
            index = toDoTasks.firstIndex(of: task)! // Will never be nil
            toDoTasks.remove(at: index)
        }
        
        // Empty completed tasks now that these items are no longer relevent
        completedTasks.removeAll()
        
        // Don't alllow users to select multiple rows now, no longer in check-off mode
        self.tableView.allowsMultipleSelection = false
        checkOffOn = false
        
        // Put the "Hide Options" button back and reload the view to show the changes
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hide Options", style: .plain, target: self, action: #selector(hideOptions))
        self.tableView.reloadData()
    }
    
    // Allow user to send tasks back after pressing "Send back"
    @objc func allowSendBack() {
        self.tableView.allowsMultipleSelection = true // Let the user pick multiple rows
        sendBackOn = true // In send back mode now
        
        // Let user finalize their choice to send tasks back
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(sendTasksBack))
    }
    
    // Sends the tasks the user has picked back to their original TaskLists
    @objc func sendTasksBack() {
        
        var index: Int // Will keep track of position in the main array
        
        // Loop through tasksToSendBack and place each item in
        for task in tasksToSendBack {
            //delegate.sendTaskBack(task) // Send the tassk back to its original list
            
            // Remove the task from the main list
            index = toDoTasks.firstIndex(of: task)!
            toDoTasks.remove(at: index)
        }
        
        // Empty tasks to send back
        tasksToSendBack.removeAll()
        
        // Don't alllow users to select multiple rows now, no longer in send back mode
        self.tableView.allowsMultipleSelection = false
        sendBackOn = false
        
        // Put the "Hide Options" button back and reload the view to show the changes
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hide Options", style: .plain, target: self, action: #selector(hideOptions))
        self.tableView.reloadData()
    }
    
   
    
   
}
