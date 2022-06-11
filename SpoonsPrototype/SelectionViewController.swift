//
//  SelectionViewController.swift
//  SpoonsPrototype
//
//  Created by Tuhin Patel on 6/8/22.
//

import UIKit

class SelectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Time for a new day!"
      
    }
    
    
    @IBAction func newDay(_ sender: UIButton) {
        // Create a new action controller pop up
        let ac = UIAlertController(title: "How many spoons do you have today?", message: nil, preferredStyle: .alert)
        
        ac.addTextField()// User enters answer here
        ac.textFields?[0].keyboardType = .numberPad // Only let user enter numbers
        
        // Create the submit button
        let submitTask = UIAlertAction(title: "Submit", style: .default) { // Trailing closure syntax
            
            [weak self, weak ac] action  in
            // Create the CateogryView
            if let vc = self?.storyboard?.instantiateViewController(identifier: "CategoryView") as? CategoryViewController {
                vc.maxSpoons = Int((ac?.textFields?[0].text ?? "20")) // Default max of 20
            
                // Push the view controller
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        // Add submit button to action controller and present it
        ac.addAction(submitTask)
        present(ac, animated: true)
        
        
    }
}
   


