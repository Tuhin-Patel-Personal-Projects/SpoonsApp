//
//  TaskViewController.swift
//  SpoonsPrototype
//  Created by Tuhin Patel on 5/13/22.
/*
    Displays a task list to the user. There is one TaskViewController for each cell in the
 CategoryViewController, meaning each one is associated with a spoon count. The title of
 the view is based upon the spoon count it is associated with. The user may press Options
 to pull up a toolbar, which will then allow them to add tasks to the list or move tasks to
 the to-do list.
 */

import UIKit

class TaskViewController: UITableViewController {
    var listName: Int! // Title of this categry
    var taskList = [Task]() // Arry of tasks to show in this list
    var selectedTasks = [Task]() // Array of tasks the user selects to send to a to-do list
    
    weak var delegate: CategoryViewController! // Need to use functions in CategoryViewController
    
  

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem?.title = "Back"
        
        // A button to let user add a task
        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addItem))
        
        // A button to enable selecting tasks to send to the to do list
        let selectTasksButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectTasks))
        
        // List the add and select button in the toolbar
        toolbarItems = [addButton, selectTasksButton]
        
        // Opens the toolbar for the user to show their options
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Options", style: .plain, target: self, action: #selector(showOptions))
        
        
        self.title = String(listName)
       
    }
    
    // How many cells are needed
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    // Create a cell for each task
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Task", for: indexPath)
        cell.textLabel?.text = taskList[indexPath.row].taskName // Add the task name to the cell
        return cell
    }
    
   
    // Enables user to delete tasks
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // This is only swipe and delete, no edit mode here
        if editingStyle == UITableViewCell.EditingStyle.delete {
            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath] , with: UITableView.RowAnimation.automatic )
        }
    }
    
    // Will mark these as tasks currently selected by the user by storing them in the
    // selectedTasks array
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // The user should only be allowed to do this if multiple-row selection is active
        if (self.tableView.allowsMultipleSelection) {
            // Move the selected item to the array
            selectedTasks.append(taskList[indexPath.row])
        }
    }
    
    // Remove a task from the selected tasks array if its row is deselected
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Safely the index of the item that should be removed, then remove at that index
        guard let index = selectedTasks.firstIndex(of: taskList[indexPath.row]) else {return}
        selectedTasks.remove(at: index)
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
    
    // Add new task to the list
    @objc func addItem() {
        let ac = UIAlertController(title: "Enter new task", message: nil, preferredStyle: .alert)
        
        // Make a new task item
        var newTask = Task()
        ac.addTextField() // User enters answer here
        
        // Create a submit action
        let submitTask = UIAlertAction(title: "Submit", style: .default) { // Trailing closure syntax
        
            
            // Specifies input into closure, use weak so that the closure does not caputure it strongly
            // Avoids strong reference cycle that retains memory for a long time
            [weak self, weak ac] action  in
           
            
            // Safely get the task name
            guard let taskName = ac?.textFields?[0].text else {return}
            
            // Fill in the new task's information
            newTask.taskName = taskName
            newTask.taskSpoonCount = (self?.listName!)!
            
            self?.taskList.append(newTask) // Add the new task to the list
            
            self?.tableView.reloadData() // Reload the view
            
        }
        
        // Create a cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            action  in print("Cancel was tapped(adding item cancelled)")
        }
        
        ac.addAction(submitTask)
        ac.addAction(cancelAction)
        
        
        present(ac, animated: true)
    }
    
    
    // When the select button is pressed, let the user start selectng tasks to send to the to-do list
    @objc func selectTasks() {
        self.tableView.allowsMultipleSelection = true // Let the user pick multiple rows
        
        // Sumbit items to be sent to the to do list
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitTasks))
        
    }
    
    // Handles the job of taking tasks selected by the user and moving them to the to-do list
    @objc func submitTasks() {
       
        var index: Int // Stores where the task is listed in the taskList array
        
        // Check if the user has surpassed their max spoons with the tasks selected
        let totalSpoonsSelected = listName * selectedTasks.count
        let maxSurpassed = delegate.spoonsOverMax(totalSpoonsSelected)
        
        // Proceed to send to to-do if the max is not surpassed
        if(!maxSurpassed) {
        
            // Update the amount of used spoons
            delegate.updateUsedSpoons(totalSpoonsSelected)
        
            // Loop through the selected task array
            for task in selectedTasks {

                // Add task to the to do list
                delegate.placeInToDo(task)
            
                // Now remove this task from the taskList
                index = taskList.firstIndex(of: task)!
                taskList.remove(at: index)
            }
        
            // Empty selected tasks now that they are gone
            selectedTasks.removeAll()
        
            // Disable the ability to select multiple rows
            self.tableView.allowsSelection = false
    
            // Let user have the option to close the toolbar again
            navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Hide Options", style: .plain, target: self, action: #selector(hideOptions))
            self.tableView.reloadData()
            
        } else {  // If the max will be surpassed, let the user cancel out and deselect some tasks
           
            // Create the message
            let ac = UIAlertController(title: "You have went over your max!", message: "Please deselect some tasks", preferredStyle: .alert)
            
            // Create an OK action to dismiss controller
            let okAction = UIAlertAction(title: "OK", style: .cancel) {
                action  in print("OK was tapped(max surpassed)")
            }
            
            // Present the message
            ac.addAction(okAction)
            present(ac, animated: true)
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
}
