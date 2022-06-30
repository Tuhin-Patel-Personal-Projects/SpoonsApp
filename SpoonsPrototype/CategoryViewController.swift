//
//  ViewController.swift
//  Spoon Task Manager App
//  Created by Tuhin Patel on 5/6/22.
//

import UIKit

class CategoryViewController: UITableViewController {
    
    var spoonCounts = [1,2,3,4,5,6,7,8,9,10] // Array containing just the categories of spoon counts the                                           // user gives. Fixing at a max of 10 spoons.
    
    
    var spoonVCs = [Int: TaskViewController]() // Associate a view controller with each spoon count
    
    var toDoList = [Task]()// Stores a to do list that the user may update (CHANGE TO ARRAY OF TASK ITEMS
    
    var maxSpoons: Int = 0 { // Stores the spoon count limit the user has input for the day
        didSet {
            self.title = "0/\(maxSpoons)" // Change title every time max spoons is changed
        }
    }
    
    var usedSpoons: Int = 0 { // Updated every time a task is added to the to-do list
        didSet {
            self.title = "\(usedSpoons)/\(maxSpoons)" // Change title every usedSpoons
                                                      // changes
        }
    }
    override func viewDidLoad() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Day", style: .plain, target: self, action: #selector(newDay)) // Lets user start a new day by entering their max spoons for the day
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "To-Do", style: .plain, target: self, action: #selector(showToDoList)) // Lets user go look at their to-do list
        
       
        super.viewDidLoad()
        
        
        
        
    }
    

    // Generate the table rows, equal to number of spoon categories
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spoonCounts.count
    }
    
    // Create the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Make a Category cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)
        
        let currSpoonCount = spoonCounts[indexPath.row] // Get the spoon count once
        cell.textLabel?.text = String(currSpoonCount) // Cast the int as a string so it can be                                                         used as a label
        
        
        
         
        // Create a view controller associated with this spoon count
        if let vc = storyboard?.instantiateViewController(withIdentifier: "TaskList") as? TaskViewController {
           
            vc.listName = currSpoonCount // Set title to be the spoon count
            vc.taskList = [String]()
            vc.delegate = self // Each task list should be able to use a delegate to give the main VC data,
                                // primarily used when adding tasks to the do list.
            
            
            
            // Add to the dicitonary of View controllers
            spoonVCs[currSpoonCount] = vc
            
        }
        return cell
    }
    
   
    
    // FUNCTIONS FOR BUTTONS ON THE SCREEN
    
    // Sends the user to a view that shows their current to do list
    @objc func showToDoList() {
        // Create the view
        if let vc = storyboard?.instantiateViewController(identifier: "ToDoList") as? ToDoListTableViewController {
            
            // Give it the array
            vc.toDoTasks = toDoList
            // Push the view controller
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    // Let user set a spoon count for their day
    @objc func newDay() {
        // Create an action controller that asks the user for today's spoon count
        let ac = UIAlertController(title: "How many spoons do you have today?", message: nil, preferredStyle: .alert)
        ac.addTextField() // User enters response here
        
        // Make it so user can only enter numbers
        ac.textFields![0].keyboardType = .numberPad
        
        // Create a submit action
        let submitSpoons = UIAlertAction(title: "Submit", style: .default) { // Trailing closure syntax
        
            
            // Specifies input into closure, use weak so that the closure does not caputure it strongly
            // Avoids strong reference cycle that retains memory for a long time
            [weak self, weak ac] action  in
            guard let todaysSpoons = ac?.textFields?[0].text else {return}
            self?.maxSpoons = Int(todaysSpoons)! // Set max spoons
            
        }
        
        // Give ac the submit action
        ac.addAction(submitSpoons)
        
        // Present the action controller
        present(ac, animated: true)
    }
    
    
    // Open the view for a specific task list
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Safely get the current cell
        guard let currCell = self.tableView.cellForRow(at: indexPath) else { return }
        
        // Get the cell's spoon count(it will always be the text)
        let rowSpoonCount = Int((currCell.textLabel?.text)!) ?? 0 // Nil coalescing to get the number
        
        // Open the view controller at this area and present it
        navigationController?.pushViewController(spoonVCs[rowSpoonCount]!, animated: true)
        
    }
    
   
    // THESE FUNCTIONS ARE CALLED BY OTHER VIEWS, NOT THIS MAIN VIEW
    
    
    // Called by TaskViewController to send to the to-do list
    func placeInToDo(_ task: Task) {
        toDoList.append(task)
    }
    
    // Called whenever a task is placed in the toDoList
    func updateUsedSpoons(_ taskSpoonCount: Int) {
        usedSpoons += taskSpoonCount
    }
    
    // Called whenever tasks are added to ensure that usedSpoons does not surpass maxSpoons
    func spoonsOverMax(_ submittedSpoons: Int) -> Bool {
        return ((submittedSpoons + usedSpoons) > maxSpoons)
    }
    
}
    
    





