//
//  ViewController.swift
//  ToDoEy
//
//  Created by Helen Karppi on 11/25/19.
//  Copyright © 2019 Helen Karppi. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["Buy Eggos", "Find Mike", "Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        
    }
    
    func loadItems() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK - Table View Data Source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        print("Top of add button pressed func")
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New ToDoEy Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happenwhen the user clicks on the add item button on the UIAlert
            print("UIAlertAction instantiated")
            print(textField.text)
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            print("Add text field")
            print(alertTextField.text!)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        print("Add action")

    }
}

