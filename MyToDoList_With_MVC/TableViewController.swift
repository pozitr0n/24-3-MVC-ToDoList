//
//  TableViewController.swift
//  MyToDoList_With_MVC
//
//  Created by Raman Kozar on 10/12/2022.
//

import UIKit

// MARK: Adding a class with table properties and methods
//
class TableViewController: UITableViewController, UISearchResultsUpdating {
    
    // MARK: Getting access to the model in which all calculations take place
    let tableModel = TableModel()
    
    // MARK: Getting access to a custom cell ID
    private var cellID: String = CustomTableCell().identifier
    
    var alert = UIAlertController()
    
    // MARK: Adding search controller
    var resultSearchController = UISearchController()
    
    // MARK: Adding the array of founded elements
    var filteredTableData = [CellItem]()
    
    // MARK: Adding outlets of navigation bar buttons
    // MARK: Adding a new task
    @IBOutlet weak var addTaskButton: UIBarButtonItem!
    
    // MARK: Sorting the task list
    @IBOutlet weak var sortingTasksButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // MARK: Determining the Presentation Context
        self.definesPresentationContext = true
        definesPresentationContext = true
    
        // MARK: Title of the application in the navigation
        title = "Task list"
        
        // MARK: Getting resultSearchController-variable
        resultSearchController = ({
            
            let controller = UISearchController(searchResultsController: nil)
           
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            
            // MARK: Adding searchBar into tableHeaderView of TableViewController
            tableView.tableHeaderView = controller.searchBar
            return controller
            
        })()
        
        // MARK: Set the table settings
        setTableSettings()
        
    }
    
    // MARK: Update search results in searchController
    func updateSearchResults(for searchController: UISearchController) {
        
        // MARK: Clearing the array of found elements
        filteredTableData.removeAll(keepingCapacity: false)
        
        // MARK: Searching using closures and .filter-function
        filteredTableData = tableModel.arrayTasks.filter({
            $0.content.localizedCaseInsensitiveContains(searchController.searchBar.text!)
        })
        
        // MARK: Updating the table
        tableView.reloadData()
        
    }
    
    // MARK: Function for setting table settings
    func setTableSettings() {
        
        // MARK: Performing a sort
        tableModel.sortAscDesc()
        
        // MARK: Set the color of the table separator
        tableView.separatorColor = .lightGray
        
        // MARK: Reloading the data
        tableView.reloadData()
        
    }

    // MARK: TableView data source
    // MARK: Standard typical methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // MARK: Getting the count of the array elements
        // MARK: If the search is active, we output the number from the array of found elements.
        // MARK: Otherwise, we display the number of all available records.
        if resultSearchController.isActive {
            return filteredTableData.count
        } else {
            return tableModel.arrayTasks.count
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // MARK: Declaring and declaring a cell by ID
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CustomTableCell
        
        // MARK: Accessing a cell delegate
        cell.delegate = self
        
        // MARK: Getting the current cell and setting the text of the task and additional settings
        
        // MARK: If the search is active, we take the index from the array of found elements.
        // MARK: Otherwise - we take an index from the general table.
        if resultSearchController.isActive {
            let currentItem = filteredTableData[indexPath.row]
            cell.customTableCellTextLabel?.text = currentItem.content
            cell.accessoryType = currentItem.taskCompleted ? .checkmark: .none
        } else {
            let currentItem = tableModel.arrayTasks[indexPath.row]
            cell.customTableCellTextLabel?.text = currentItem.content
            cell.accessoryType = currentItem.taskCompleted ? .checkmark: .none
        }
        
        return cell
        
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: Status change (whether the task is completed or not, when done,
    // MARK: put a "tick" and do not change the color of the cell, only select it temporarily)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableModel.changeTaskStatus(at: indexPath.row) == true {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            tableView.cellForRow(at: indexPath)?.backgroundColor = .clear
            
        } else {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            tableView.cellForRow(at: indexPath)?.backgroundColor = .clear
            
        }
        
    }

    override func tableView(_ tableView: UITableView,  commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:IndexPath) {
      
        if editingStyle == UITableViewCell.EditingStyle.delete{
            tableModel.arrayTasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        
    }
    
    func editCellContent(indexPath:IndexPath) {

        // MARK: Accessing an editable cell
        let cell = tableView(tableView, cellForRowAt: indexPath) as! CustomTableCell
        
        alert = UIAlertController(title: "Input the task", message: nil, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {(textField) -> Void in
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
            textField.text = cell.customTableCellTextLabel.text
        })
        
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let editAlertAction = UIAlertAction(title: "Change the task", style: .default) { (createAlert) in
            
            guard let textField = self.alert.textFields, textField.count > 0 else { return }
            guard let textValue = self.alert.textFields?[0].text else { return }
            
            self.tableModel.updateTask(at: indexPath.row, with: textValue)
            self.tableView.reloadData()
            
        }
        
        alert.addAction(cancelAlertAction)
        alert.addAction(editAlertAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func alertTextFieldDidChange (_ sender: UITextField) {
        
        guard let senderText = sender.text, alert.actions.indices.contains(1) else { return }
        let action = alert.actions[1]
        action.isEnabled = senderText.count > 0
        
    }
    
    // MARK: Clicking on the add task button
    @IBAction func addTaskButtonAction(_ sender: Any) {
        
        alert = UIAlertController(title: "New task", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "You can write a new task..."
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
        }
        
        let creatAlertAction = UIAlertAction(title: "Create", style: .default) { (createAlert) in
            
            guard let unwrTextFieldValue = self.alert.textFields?[0].text else { return }
            
            self.tableModel.addTask(taskName: unwrTextFieldValue)
            self.tableModel.sortAscDesc()
            self.tableView.reloadData()
            
        }
        
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(creatAlertAction)
        alert.addAction(cancelAlertAction)
        
        present(alert, animated: true, completion: nil)
        creatAlertAction.isEnabled = true
        
    }
    
    // MARK: Clicking on the sort task button
    @IBAction func sortingTaskButtonAction(_ sender: Any) {
        
        // MARK: Images of the changing the sorting direction
        let arrowUp = UIImage(systemName: "arrow.up")
        let arrowDown = UIImage(systemName: "arrow.down")
        
        // MARK: Getting the previous state of the sorting
        let prevSortCondition = tableModel.sortAsc
        
        tableModel.sortAsc = !prevSortCondition
        sortingTasksButton.image = tableModel.sortAsc ? arrowUp : arrowDown
        
        tableModel.sortAscDesc()
        tableView.reloadData()
        
    }
    
}

// MARK: Extension for implementing delegation by subscribing to the CustomTableCellDelegate protocol
extension TableViewController: CustomTableCellDelegate{
   
    // MARK: Function of the editing cell
    func editCell(cell: CustomTableCell) {
        
        let indexPath = tableView.indexPath(for: cell)
        guard let unwrIndexPath = indexPath else { return }
        
        self.editCellContent(indexPath: unwrIndexPath)
        
    }
    
    // MARK: Function of the deleting cell
    func deleteCell(cell: CustomTableCell) {
       
        let indexPath = tableView.indexPath(for: cell)
        guard let unwrIndexPath = indexPath else{return}
        
        tableModel.removeTask(at: unwrIndexPath.row)
        tableView.reloadData()
        
    }
    
}
