//
//  ViewController.swift
//  Spoon Task Manager App
//
//  Created by Tuhin Patel on 5/6/22.
//

import UIKit

class ViewController: UITableViewController {
    var taskList = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editItems))
        
        
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Task", for: indexPath)
        cell.textLabel?.text = taskList[indexPath.row]
        
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
            self?.taskList.append(newTask)
            self?.tableView.reloadData()
            
        }
        ac.addAction(submitTask)
        present(ac, animated: true)
        
         
    }
    
    // Handles what to do when the edit button is tapped
    @objc func editItems() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        if tableView.isEditing {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(editItems))
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editItems))
        }
        
        
    }
    
    // Enables deleting in edit mode only
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete && !isEditing {
            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath] , with: UITableView.RowAnimation.automatic )
        }
    }
    
    // Enables swapping in edit mode
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        taskList.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    



}

