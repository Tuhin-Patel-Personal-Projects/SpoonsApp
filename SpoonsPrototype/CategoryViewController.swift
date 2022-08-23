//
//  CategoryViewController.swift
//  Spoon Task Manager App
//  Created by Tuhin Patel on 5/6/22.

/*
   This is the initial view of the app. In the table are 10 cells, labeled 1-10,
 representing the spoon counts the user can give to a task. These each lead to
 a TaskViewController. The options button will bring up a toolbar. The user may start a ne
 w  day and enter a max spoon count, which will then be displayed in the title as "# of
 spoons used/max # of spoons". They may also go to their to-do list or a list of their
 backlogged tasks.
 */

import UIKit

class CategoryViewController: UITableViewController {
    
    final var spoonCounts = [1,2,3,4,5,6,7,8,9,10] // Array containing just the categories of spoon counts
    var spoonVCs = [Int: TaskListViewController]() // Associate a view controller with each spoon count
    
    var toDoList = [Task]() // Stores a to do list that the user may update
    
    var backlogItems = [Task]() // Stores any tasks the user does not complete after a day
    
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
        
        // Lets user start a new day by entering their max spoons for the day
        let newDayButton =  UIBarButtonItem(title: "New Day", style: .plain, target: self, action: #selector(newDay))
        
        // Lets user go look at their to-do list
        let viewToDoButton = UIBarButtonItem(title: "To-Do", style: .plain, target: self, action: #selector(showToDoList))
        
        // Show the user a list of backlog items from previous days' to-do lists
        let backlogButton = UIBarButtonItem(title: "Backlog", style: .plain, target: self, action: #selector(showBacklog))
        
        // Add options to the toolbar
        toolbarItems = [newDayButton, viewToDoButton, backlogButton]
        
        // Opens the toolbar for the user to show their options
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Options", style: .plain, target: self, action: #selector(showOptions))
        
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
        if let vc = storyboard?.instantiateViewController(withIdentifier: "TaskList") as? TaskListViewController {
           
            vc.listName = currSpoonCount // Set title to be the spoon count
            vc.taskList = [Task]()
            vc.delegate = self // Each task list should be able to use a delegate to use the Category View's data/functions
                               
            // Add to the dicitonary of View controllers
            spoonVCs[currSpoonCount] = vc
            
        }
        return cell
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
    
   
    
    // FUNCTIONS FOR BUTTONS ON THE SCREEN
    
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
    
    // Sends the user to a view that shows their current to do list
    @objc func showToDoList() {
        // Create the view
        if let vc = storyboard?.instantiateViewController(identifier: "ToDoList") as? ToDoListTableViewController {
 
            // Sort array by spoon counts, least to greatest
            toDoList.sort {
                $0.taskSpoonCount < $1.taskSpoonCount
            }
            
            // Give it the array
            vc.toDoTasks = toDoList
            
            // Construct the dictionary
            vc.toDoTasksDict = Dictionary(grouping: toDoList) { (task) -> Int in
                return task.taskSpoonCount
            }
            
            // Set the delegate
            vc.delegate = self
            
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
            self?.usedSpoons = 0 // Reset used spoons to 0
            
            // Append the toDoList to the backlog, then empty the toDoList
            self?.backlogItems.append(contentsOf: self!.toDoList)
            self?.toDoList.removeAll()
        }
        
        // Create an action that lets the user cancel out of the window
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            action  in print("Cancel was tapped(new day canceled)")
        }
        
        // Give ac the submit action and cancel action
        ac.addAction(submitSpoons)
        ac.addAction(cancelAction)
        
        // Present the action controller
        present(ac, animated: true)
    }
    
    // Show user their list of backlogged items
    @objc func showBacklog() {
        // Create the view
        if let vc = storyboard?.instantiateViewController(identifier: "BacklogView") as? BacklogViewController {
            
            // Give it the array of backlog items
            vc.backlogItems = backlogItems
            
            // Set the delegate
            vc.delegate = self
            
            // Push the view controller
            navigationController?.pushViewController(vc, animated: true)
        
        }

    }
   
    // THESE FUNCTIONS ARE CALLED BY OTHER VIEWS, NOT THIS MAIN VIEW
    
    // Called by TaskViewController to send to the to-do list
    func placeInToDo(_ task: Task) {
        toDoList.append(task)
    }
    
    // Called whenever a task is removed from to-do list.
    func removeFromToDo(_ task: Task) {
        let index = toDoList.firstIndex(of: task)!
        toDoList.remove(at: index)
    }
    
    // Called whenever a task is placed in the toDoList
    func updateUsedSpoons(_ taskSpoonCount: Int) {
        usedSpoons += taskSpoonCount
    }
    
    // Called whenever tasks are added to the to-do list, ensures that usedSpoons does not surpass maxSpoons
    func spoonsOverMax(_ submittedSpoons: Int) -> Bool {
        return ((submittedSpoons + usedSpoons) > maxSpoons)
    }
    
    // Remove item from the backlog array
     func removeFromBacklog(_ task: Task) {
        let index = backlogItems.firstIndex(of: task)!
        backlogItems.remove(at: index)
        
    }
    
    
    
    
    
    
}
    
    



