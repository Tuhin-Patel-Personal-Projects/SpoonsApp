//
//  TaskViewController.swift
//  SpoonsPrototype
//
//  Created by Tuhin Patel on 5/13/22.
//

import UIKit

class TaskViewController: UITableViewController {
    var listName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = listName {
            self.title = name
        }

        // Do any additional setup after loading the view.
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
