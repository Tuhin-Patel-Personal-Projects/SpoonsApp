//
//  TaskViewController.swift
//  SpoonsPrototype
//
//  Created by Tuhin Patel on 5/13/22.
//

import UIKit

class TaskViewController: UITableViewController {
    var listName: String! // Title of this categry
    weak var delegate: ViewController!
    var taskList = [String]() // Arry of tasks to show in this list
    var selectedTasks = [String]() // Array of tasks the user selects to send to a to-do list

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.leftItemsSupplementBackButton = true
        // An add button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addItem))
        
        // A button to enable selecting tasks to send to the to do list
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectTasks))
        
        // Set the title
        if let name = listName {
            self.title = name
        }

       
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
    
    // Add new task to the main list
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
    
    // Enables deleting
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // This is only swipe and delete, no edit mode here
        if editingStyle == UITableViewCell.EditingStyle.delete {
            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath] , with: UITableView.RowAnimation.automatic )
        }
    }
    
    // Will mark these as tasks currently selected by the user
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
    
    
    

    
    // When the select button is pressed, let the user start selectng tasks to send to the to-do list
    @objc func selectTasks() {
        self.tableView.allowsMultipleSelection = true // Let the user pick multiple rows
        
        // Sumbit items to be sent to the to do list
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitTasks))
        
    }
    
    // Handles the job of taking tasks selected by the user and moving them to the to-do list
    @objc func submitTasks() {
       
        var toDoString: String // Will be of the format "taskName, spoonCount", will be sent to to-do list
        var index: Int // Stores where the task is listed in the taskList array
        
        // Loop through the selected task array
        for task in selectedTasks {
            // Will want to remove the list from the main tasklist so that it can later be reviewed from view
            index = taskList.firstIndex(of: task)! // Will never be nil, so force unwrap
            taskList.remove(at: index)
            
            // Construct the final string
            toDoString = "\(task), \(listName!)"
            
            // Now add to the to do list
            delegate.placeInToDo(toDoString)
        }
        
        // Disable the ability to select multiple rows
        self.tableView.allowsSelection = false
        
        
        // Lastly, re-add the select button and reload the table view to remove all of the final selections
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectTasks))
        self.tableView.reloadData()
        
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
