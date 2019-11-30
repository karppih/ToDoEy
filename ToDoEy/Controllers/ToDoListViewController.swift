//
//  ViewController.swift
//  ToDoEy
//
//  Created by Helen Karppi on 11/25/19.
//  Copyright © 2019 Helen Karppi. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        
        
//        let titleList = ["Find Mike", "Kill the Demogorgon", "Have fun"]
//        for newTitle in titleList {
//            var newItem = Item()
//            newItem.title = newTitle
//            itemArray.append(newItem)
//        }
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]  {
//            itemArray = items
//        } else {
//            print("error loading item list from user defaults")
//        }
        loadItems()
        loadTable()
        
    }
    
    func loadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK - Table View Data Source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
//        ternary operator
        cell.accessoryType = item.done ? .checkmark : .none
//
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row].title)
        print(itemArray[indexPath.row].done)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveItems()
        
    }
    
    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        print("Top of add button pressed func")
        var textField = UITextField()
        var item = Item()

        let alert = UIAlertController(title: "Add New ToDoEy Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happenwhen the user clicks on the add item button on the UIAlert
            print("UIAlertAction instantiated")
            print(item.title)
            item.title = textField.text!
            self.itemArray.append(item)
            
            self.saveItems()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            item = Item()
            item.title = alertTextField.text!
            textField = alertTextField
            print("Add text field")
            print(item.title)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        print("Add action")

    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        
            if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
                do {
                itemArray = try decoder.decode([Item].self, from: data)
                } catch {
                    print(error)
                }
        }
        tableView.reloadData()
    }
}

