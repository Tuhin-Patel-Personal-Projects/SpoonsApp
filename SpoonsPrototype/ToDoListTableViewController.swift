//
//  ToDoListTableViewController.swift
//  SpoonsPrototype
//  Created by Tuhin Patel on 5/18/22.
/*
    Displays a user's to-do list. Each task is shown by displaying the task name and then
 the spoon count associated with the task. By pressing Options, the toolbar is displayed.
 This allows a user to check items off of their to-do list.
 */

import UIKit

class ToDoListTableViewController: UITableViewController {
    var toDoTasks = [Task]() /* Tasks that have been sent to the to-do list, this is mainly
                                used to be able to communicate with CategoryViewController  when items have been checked off*/
    
    var completedTasks = [Task]() // Tasks selected by the user that have been completed
    
    var toDoTasksDict = [Int: [Task]]() /* Dictionary that groups tasks with the same spoon                                 count, this is what's used to lay out the rows and                                    sections */

    weak var delegate: CategoryViewController! // Need to use functions/variables in CategoryViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        
        // Will let the user check items off of their to-do list
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Check Off", style: .plain, target: self, action: #selector(allowCheckOff))
        
        // Make the title To-Do
        self.title = "To-Do"

       
    }
    
    // Section out the table view into categories for each spoon-count value
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 11 // Returning 10 here would only give enough sections for spoon counts 1-9
    }
   
    // One row per task
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.toDoTasksDict[section]?.count ?? 0
    }
    
    // Create a cell for each task
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(indexPath.section)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItem", for: indexPath)
        
        // Get the next task by going into this section's array
        let task = self.toDoTasksDict[indexPath.section]?[indexPath.row]
        
        cell.textLabel?.text = "\(task!.taskName), \(task!.taskSpoonCount)" // Display in the format of "name, spoonCount"
        
        return cell
    }
    
    // Add headers to the top of each section showing the spoon-category
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Make a colored background for the title of the section to be placed on
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height:  30))
        headerView.backgroundColor = .gray
        
        // Make a label to show the spoon count
        let headerLabel = UILabel(frame: CGRect(x: 15, y: 0, width: headerView.frame.width - 15 , height: 30))
        headerLabel.font = UIFont.systemFont(ofSize: 21)
        headerLabel.text = String(section)
        
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    // Add whitespace between sections so that adjacent sections never have touching headers
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    // Marks a task as having been selected by the user while marking tasks as done
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // If multiple selection is on, add this task to the completedTasks arrat
        if (self.tableView.allowsMultipleSelection) {
            completedTasks.append((toDoTasksDict[indexPath.section]?[indexPath.row])!)
        }
    
    }
    
    // Remove a task from the array of completed items if it is deselected
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // If multiple selection is on , remove task from completedTasks array
        if (self.tableView.allowsMultipleSelection) {
            // Get the Task from this row
            if let deselectedTask = toDoTasksDict[indexPath.section]?[indexPath.row] {
                if let index = completedTasks.firstIndex(of: deselectedTask) {
                    completedTasks.remove(at: index)

                }
                
            }
            
        }
    }
    
    
    // FUNCTIONS FOR ON-SCREEN BUTTONS
    
    // When the user presses "Check off, they should be allowed to select multiple
    // tasks
    @objc func allowCheckOff() {
        self.tableView.allowsMultipleSelection = true // Let the user pick multiple rows
        
        
        
        // Submits selected items to be removed from the to-do list
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
            
            // Find task in the dictionary and remove it from there too.
            index = (toDoTasksDict[task.taskSpoonCount]?.firstIndex(of: task)!)!
            toDoTasksDict[task.taskSpoonCount]?.remove(at: index)
            
            // Also need to remove from ToDo array in the main view, otherwise this item will not be permamnetly deleted
            delegate.removeFromToDo(task)
        }
        
        // Empty completed tasks now that these items are no longer relevent
        completedTasks.removeAll()
        
        // Don't alllow users to select multiple rows now, no longer in check-off mode
        self.tableView.allowsMultipleSelection = false
        
        
        // Put the "Check off" button back and reload the view to show the changes
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Check Off", style: .plain, target: self, action: #selector(allowCheckOff))
        self.tableView.reloadData()
    }
}
