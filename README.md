# SpoonsApp
An app currently in-progress that allows users to manage their tasks using the spoon theory approach. Many people with varying conditions run on a 
limited supply of energy every day. They do not always have the luxury of getting many difficult tasks done in a day, and can find it hard managing their
time and energy. Some of us(like myself) may not have those conditions and still feel we have only so much energy we can dedicate to tasks in the day. 
This is where spoon theory comes in. I won't go over too many of the specifics here, but the basis is that one starts a day off with a certain amount of
"spoons"(which are used to quantify energy), and tasks will take a varying amount of spoons away from them. Thus those who utilize spoon theory often use
it to define a number of spoons they have in a day(which can vary) and plan out what tasks they will/can get done on a given day.

My current plan for the app is this: Users are able to create different cateogries defined by an assigned spoon-count, which will be listed on a page. 
Clicking on one of the  categories leads to a page where one may create a list of tasks that will take that amount of spoons. Once one has finished this,
they may then select tasks to place in a to-do list, and can remove tasks as they go. If any tasks are not done, they will be returned to their task lists.
Some advance features would be additions such as automatically putting certain tasks into the daily list every day(such as showering, as they do take up 
spoons for some), and also allowing a user to fix a max # of spoons they have in a given day that the app will then enforce. 

PROGRESS UPDATES:

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
