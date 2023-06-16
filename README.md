# SpoonsApp
An app that is currently a work-in-progress that allows users to manage their tasks using the spoon theory approach. Many people with varying conditions run on a limited supply of energy every day. They do not always have the luxury of getting many difficult tasks done in a day, and can find it hard managing their time and energy. Some of us(like myself) may not have those conditions and still feel we have only so much energy we can dedicate to tasks in the day. This is where spoon theory, created by Christine Miserandino comes in. I will not go over too many of the specifics here, but the basis is that one starts a day off with a certain amount of "spoons"(which are used to quantify energy), and tasks will take a varying amount of spoons away from them. Thus those who utilize spoon theory often use it to define a number of spoons they have in a day(which can vary) and plan out what tasks they will/can get done on a given day based on that number. Note that the number of spoons a task requires and how many spoons one starts a day with usually vary from person-to-person, and also day-by-day. For more information on Spoon Theory, read Christine Miserandino's original description of it here: https://lymphoma-action.org.uk/sites/default/files/media/documents/2020-05/Spoon%20theory%20by%20Christine%20Miserandino.pdf

My current plan for the app is this: Users are able to create different cateogries defined by an assigned spoon-count, which will be listed on a page. Clicking on one of the categories leads to a page where one may create a list of tasks that will take that amount of spoons. Once one has finished this, they may then select tasks to place in a to-do list, and can remove tasks as they go. If any tasks are not done, they will be returned to their task lists. Some advance features would be additions such as automatically putting certain tasks into the daily list every day(such as showering, as they do take up spoons for some), and also allowing a user to fix a max # of spoons they have in a given day that the app will then enforc(OLD)

Here is a quick rundown of how the app functions: The user begins by entering in how many spoons they have today. The initial screen displays ten categories, defined by a number of spoons. The user may enter tasks into these categories to categorize the tasks they have to do based on spoons-needed. They may send any task entered into these categories to a to-do list, so long as they do not surpass the max number of spoons they had set for themselves. If any tasks are left in the to-do list when the day is done, they will be sent to a list of backlogged tasks that the user may send to the to-do list as well.

For more detailed descriptions of each view and its contents, see below:

Task Struct
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	
  This struct is used to store the data for every new task the user creates in the app.
  
CategoryViewController
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

This is the initial view controller. The view has a right bar button which can be toggled between “Show Options” and “Hide Options”. When Show Options is pressed, the toolbar will open at the bottom of the screen, which has 3 buttons:

New Day: Begins a new day. The user will be prompted to have how many spoons they are starting the day with. Once they have entered a number and hit submit, two things happen. First, the top of the view now shows how many spoons the user has used out of their total spoons. Secondly, any tasks that were left in the to-do list are move to the backlog.

To-Do: Switches to the ToDoListViewController to show the user their to-do list

Backlog: Switches to the BacklogViewController to show the user their backlog

Lastly on this view are ten rows, labeled 1-10. Tapping on a one row leads to a TaskListViewController. These will be used by the user to categorize their tasks based on the amount of spoons each task requires.


TaskListViewController
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

This view stores a list o tasks. The tasks in a task list all have the same spoon count, denoted by the number at the top of the view. These tasks lists allow a user to organize their tasks based on the amount of spoons required, making it simpler for them to create a to-do list based on their maximum spoon count. Similar to CategoryViewController, there is a right bar button which can be toggled between “Show Options” and “Hide Options,” which will show or hide the toolbar at the bottom of the screen respectively. This view has two buttons in its toolbar:

Add: Allows a user to add a task to the list

Select: Changes the right bar button to “Submit” and allows a user to select multiple of the tasks in the list. Once Submit is pressed, all selected tasks are sent to the to-do list. “Hide Options” becomes the right bar button again. However, if the tasks submitted would cause the user to expend more spoons than their maximum, a warning appears and asks them to select less tasks. 

ToDoListViewController
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

This view lets the user look at their to-do list. The to-do list is split into ten sections, labeled 1-10, representing spoon-count values. Tasks sent to the to-do list will be listed in the appropriate section, allowing a user to quickly find tasks that require a certain amount of spoons. This view’s right bar button is “Check off”.  Pressing it will change the right bar button to “Done,” and allow the user to select tasks they wish to remove from the to-do list. Once “Done” is pressed, the deleted tasks are removed and the right bar button becomes “Check off” again.

BacklogViewController
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Stores a list of the user’s backlog tasks. Tasks are sent here when a user begins a new day while there are still tasks in the to-do list. The right-bar button for this view is “Select,” which functions the same as the Select button is TaskListViewController. For each row with a task in it, the information is displayed as “taskName, taskSpoonCount”

PROGRESS UPDATES:
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

5-14-2022: The app is currently getting closer to having bare mininum functionality. The inital page has been created, which allows users to add categories
and also delete/reorder them. Each newly added category can send the user to a task list page, where they may add tasks and, just like the inital page,
delete/reorder items in the list.

5-16-2022: There were some core changes made to the app. Firstly, I decided to remove the ability of the user to create their own categories. This could
add to needless confusion, especially when numbered categories start getting shifted around in an unorganized way. Instead, there are now ten spoon 
categories already made, labeled 1-10. Secondly, I have began to research into ways to get a to-do list going. There is a dictionary in the main view
controller now to store the to-do list, and i have created a bar button that will let the user view their to-do list. It is currently non-functional as
its selector method is empty. Lastly, each TaskList will now have its own delegate back to the main view controller. This will make it easier to pass data from a TaskList to the main view controller. This is mainly needed so that users may add tasks to their to-do list.

5-17-2022: There is now a left-bar button item on the TaskLists views. By default it is Select, which allows users to then select multiple rows. The left-bar button turns into Submit during this time. Once Submit is pressed, all selected tasks are moved to a to-do list and removed from the view.

5-18-2022: Fixed an issue where the user could still collect multiple rows in the TaskViews after pressing Submit. Also corrected an issue with the 
TaskViews where thee presence of the Select/Submit buttons removed the Back button. Lastly, added function to the "View To-Do List" button by having it
bring up a list of all the tasks currently placed there.

5-19-2022: Added functionality to the to-do list view that lets the user mark tasks as done so that they can be removed from the view.

5-20-2022: Minor change, removed an array from ViewController.swift called taskLists as it served no real purpose

5-22-2022: Modified the Task struct to now have an initalizer, making it possible to create changeable instances of it. Task also now confroms to equatable, allowing arrays of Tasks to have firstIndexOf used on them. Lastly, the toDoListviewController's code was changed to now store all of its data in arrays of Task structs instead of Strings. This will be used for implementing a feature later where users can send a task back to its original task list.

6-09-2022: Created a new view controller called SelectionViewController. This view has a single button which the user will be able to select to enter what their spoon count for that given day is. Functionality for this button will be added soon.

6-11-2022: Renamed the ViewController.swift file to CategoryViewController to better specify its purpose of showing the spoon categories. Changed SelectionViewController to the default ViewController and added functionality to the button to now let a user enter their spoons for the day. Upon hitting submit, a CategoryView is shown.

6-14-2022: Decided that the approach with SelectionViewController does not accomplish the desired result. Moved CategoryView back to the main view, and added a new button called New Day. When pressed, the user may enter how many spoons they have for that given day, and the title will update to show how many spoons they have used out of their maximum spoon count. The number of used spoons is based upon items added to the to-do list. Also their is an issue with back buttons not showing the correct text.

6-18-2022: Added a new function in CategoryView and an extra line in TaskView controller to now update the usedspoons/maxSpoons title at the top of the Category View

6-22-2022 Have decided to begin transtioning toDoListViewController and TaskViewController over to having only two buttons, a back button and a "Show Options" button, which will then display other buttons in the toolbar. This change has been partially implemented for toDoListViewController. Lastly, renamed the "Mark as done" button in toDoListViewController to "Check off" to allow for more space in the toolbar.

6-23-2022: Added hideOptions button to toDoListViewController to allow users to hide the toolbar after they are done with it. Also adjusted some
lines and functions to remove bugs that were a result of moving the Check off button to the toolbar.

6-24-2022: Added an Options button to the TaskList views, with the Add and Select buttons now being added to the toolbarItems. The Submit button will still appear as a right bar button item, and will be replaced with the Hide Options button after it is pressed.  

6-30-2022: Made it so that if a user's used spoons will go over their max spons when sending task to the to-do list, the action is stopped and the user is asked to deselect some tasks.

7-07-2022: Added the Options button to the CategoryView, with New Day and View To-Do now in the toolbar items. Note that the code commmitted today has some sphagetti code that will soon be refactored/removed. This code was meant to allow users to send a task in the To-Do List back to its original TaskView. However, it has been decided this feature would require too many changes to how the Views interact currently, and thus an alternative will soon be implemented instead. Lastly, the SelectionViewController was fully deleted as no purpose has been found for it.

7-08-2022: Added the BacklogViewController. The plan for this view is that whenever New Day is pressed, any tasks left in the To-Do list will be sent to the Backlog list. This view will then function similarly to a TaskView, with the key difference being that the user will not be able to directly add tasks to it. Also, a bug was found where whenever a user checked tasks off the to-do list, if the to-do list was exited and re-entered, the tasks would appear again. This issue has been fixed.

7-09-2022: Added a button to the CategoryViews' toolbar that can be used to view the backlog of incomplete tasks from previous days. Modified the New Day button to now also move all of the to-do list's contents to the backlog before emptying the to-do list.

7-10-2022: Added Select/Submit buttons to the BacklogViewController as rightBarButton items, they are almost identical to the Select/Submit butons in TaskViewController. Also updated the newDay function in the CategoryViewController. During tests it was found that the usedSpoons variable was not being set to 0 every time a new day was started, and this caused some bugs that are now gone.

7-12-2022: Added commented explanations at the top of each view controller file and the file containing the Task struct to state their purposes and the general layout of each view.

7-21-2022: Due to the ToDoList View only having one toolbar item, Check off, the Options/Hide Options buttons were removed and now the right bar button item will always be either Check off or Done. Also added the option to cancel out of the action controller for when a user presses New Day in the CategoryView or Add in the TaskView

7-22-2022: Modified TaskViewController to use the Task struct in its arrays. This makes it more consistent with what other views are using to store information.

8-04-2022: The past few commits have all been used in setting up the ToDoListviewController to use sections as a way of easily organizing tasks based on their spoon counts. Now that the sections have fully been implemented with headers, most of the currently planned updates to the app's basic UI and features have been implemented. Future commmits will address improving the UI of the ToDoListViewController to look more clean and organized.

8-19-2022: Added whitespace between sections in the to-do list, allows the sections to look more distinct. Was mainly done because sections could be directly adjacent to each other before when two sections had no contents.

8-23-2022: Changed the name of TaskViewController to TaskListViewController for the sake of clarity. Also fixed a bug in ToDoListViewController where deselecting a row caused the app to crash
