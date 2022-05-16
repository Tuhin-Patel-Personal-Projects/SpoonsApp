//
//  TaskViewController.swift
//  SpoonsPrototype
//
//  Created by Tuhin Patel on 5/13/22.
//

import UIKit

class TaskViewController: UITableViewController {
    var listName: String? // Title of this categry
    weak var delegate: ViewController!
    var taskList = [String]() // Arry of tasks to show in this list

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // An add button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addItem))
        
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
    
    // Enables swapping, same as swapping for the main view
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        taskList.swapAt(sourceIndexPath.row, destinationIndexPath.row)
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
