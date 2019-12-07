//
//  ViewController.swift
//  ToDoEy
//
//  Created by Helen Karppi on 11/25/19.
//  Copyright © 2019 Helen Karppi. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory: Category? {
           didSet{
               loadItems()
           }
       }
       
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    
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
//        loadItems()
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
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

        
        tableView.deselectRow(at: indexPath, animated: true)
        
        print(itemArray[indexPath.row].title)
        print(itemArray[indexPath.row].done)
        
        saveItems()
        
    }
    
    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        print("Top of add button pressed func")
        var textField = UITextField()
        var item = Item(context: context)

        let alert = UIAlertController(title: "Add New ToDoEy Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happenwhen the user clicks on the add item button on the UIAlert
            print("UIAlertAction instantiated")
//            var item = Item(context: self.context)

            print(item.title)
            item.title = textField.text!
            item.done = false
            self.itemArray.append(item)
            
            self.saveItems()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
//            let item = Item(context: self.context)
            item.title = alertTextField.text!
            item.done = false
            item.parentCategory = self.selectedCategory
            textField = alertTextField
            print("Add text field")
            print(item.title)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        print("Add action")

    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        
        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let existingPredicate = request.predicate {
            let combinedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, existingPredicate])
            request.predicate = combinedPredicate
            
        } else {
            
            request.predicate = predicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching dta from context \(error)")
        }
        tableView.reloadData()
    }
    

}

//MARK: - Search Bar Methods
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request)
        
//        chagne somenginte
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()

            }
        }
    }
}
