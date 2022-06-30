//
//  TaskViewController.swift
//  SpoonsPrototype
//
//  Created by Tuhin Patel on 5/13/22.
//

import UIKit

class TaskViewController: UITableViewController {
    var listName: Int! // Title of this categry
    weak var delegate: CategoryViewController!
    var taskList = [String]() // Arry of tasks to show in this list
    var selectedTasks = [String]() // Array of tasks the user selects to send to a to-do list
    
  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        
        self.navigationItem.backBarButtonItem?.title = "Back"
        // An add button
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
        cell.textLabel?.text = taskList[indexPath.row] // Add the task name to the cell
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
    
    // Will mark these as tasks currently selected by the user by storing them in another
    // arrat
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // The user should only be allowed to do this if multiple-row selection is active
        if (self.tableView.allowsMultipleSelection) {
            
            // Safely get the current cell
            guard let currCell = self.tableView.cellForRow(at: indexPath) else { return }
            
            // Safely get the text
            guard let cellContents = currCell.textLabel?.text else { return }
            
            // Move the selected item to the array
            selectedTasks.append(cellContents)
        }
    }
    
    // Remove a task from the selected tasks array if its row is deselected
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Safely get the current cell
        guard let currCell = self.tableView.cellForRow(at: indexPath) else { return }
        
        // Safely get the text
        guard let cellContents = currCell.textLabel?.text else { return }
        
        // Safely the index of the item that should be removed, then remove at that index
        guard let index = selectedTasks.firstIndex(of: cellContents) else {return}
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
        ac.addTextField() // User enters answer here
        
        let submitTask = UIAlertAction(title: "Submit", style: .default) { // Trailing closure syntax
        
            
            // Specifies input into closure, use weak so that the closure does not caputure it strongly
            // Avoids strong reference cycle that retains memory for a long time
            [weak self, weak ac] action  in
            guard let newTask = ac?.textFields?[0].text else {return}
            self?.taskList.append(newTask) // Add the new task to the list
            
            self?.tableView.reloadData() // Reload the view
            
        }
        ac.addAction(submitTask)
        
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
        
        
        var toDoItem = Task() // Will be used to send Task items to the toDoList array
        
        // Check if the user has surpassed their max spoons with the tasks selected
        let totalSpoonsSelected = listName * selectedTasks.count
        let maxSurpassed = delegate.spoonsOverMax(totalSpoonsSelected)
        
        // Proceed to send to to-do if the max is not surpassed
        if(!maxSurpassed) {
        
            // Update the amount of used spoons
            delegate.updateUsedSpoons(totalSpoonsSelected)
        
            // Loop through the selected task array
            for task in selectedTasks {

                // Construct the final task
                toDoItem.taskName = task
                toDoItem.taskSpoonCount = listName
            
                // Now add to the to do list
                delegate.placeInToDo(toDoItem)
            
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
        } else {
            // If the max will be surpassed, let the user cancel out and deselect some tasks
            let ac = UIAlertController(title: "You have went over your max!", message: "Please deselect some tasks", preferredStyle: .alert)
            
            // Create an OK action to dismiss controller
            let okAction = UIAlertAction(title: "OK", style: .cancel) {
                action  in print("OK was tapped")
            }
            
            // Present the action controller
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
