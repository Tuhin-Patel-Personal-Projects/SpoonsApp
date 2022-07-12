//
//  Task.swift
//  SpoonsPrototype
//  Created by Tuhin Patel on 5/20/22.
/*
    Stores the name of a task and the spoon count given to it. Used by
 ToDoListViewController and BacklogViewController, as these views need to display both the
 name of a task and its spoon count.
 */

import Foundation

// Stores a task that is created by the user
struct Task: Equatable {
   var taskName: String // Name/text description of the task
   var taskSpoonCount: Int // # of spoons the task will consume
    
    // Basic initalizer for Task struct
    init() {
        self.taskName = "TBD"
        self.taskSpoonCount = 1
    }
    
    // Conform to equatable so that we can use index of to search for Task items in arrys
    static func ==(lhs: Task, rhs: Task) -> Bool {
        return (lhs.taskName == rhs.taskName) && lhs.taskSpoonCount == rhs.taskSpoonCount
    }
}
