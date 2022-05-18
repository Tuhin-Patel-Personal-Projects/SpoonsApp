//
//  ToDoListTableViewController.swift
//  SpoonsPrototype
//
//  Created by Tuhin Patel on 5/18/22.
//

import UIKit

class ToDoListTableViewController: UITableViewController {
    var toDoTasks = [String]() // Tasks selected by user to place in to do list

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        cell.textLabel?.text = toDoTasks[indexPath.row] // Labels are in format of                                                      //"taskName, spoonCount"
        
        return cell
    }

   
}
