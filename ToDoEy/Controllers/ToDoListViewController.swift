//
//  ViewController.swift
//  ToDoEy
//
//  Created by Helen Karppi on 11/25/19.
//  Copyright © 2019 Helen Karppi. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
           didSet{
               loadItems()
           }
       }
       
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
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
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none

        } else {
            cell.textLabel?.text = "No items added"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        print(toDoItems?[indexPath.row].title)
        //        print(toDoItems?[indexPath.row].done)
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
//                    realm.delete(item)
                    item.done = !item.done
                }
                } catch {
                    print("Error changing status \(error)")
                }
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
            
//            print(toDoItems?[indexPath.row].title)
//            print(toDoItems?[indexPath.row].done)
            
            //        saveItems()
            
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

            item.title = textField.text!
            item.createDate = Date()
            
            if let currentCategory = self.selectedCategory {
               
                
            
            do {
                try self.realm.write {
                    self.realm.add(item)
                    item.title = textField.text ?? "No item added"
                    currentCategory.items.append(item)
                }
            } catch {
                print("Error saving new items \(error)")
            }
            }
            
            self.tableView.reloadData()


        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            print("Add text field")
            print(item.title)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        print("Add action")

    }
    
//    func saveItems(item: Item) {
//        do {
//            try realm.write() {
//                realm.add(item)
//            }
//        } catch {
//            print("Error saving context \(error)")
//        }
//        self.tableView.reloadData()
//    }
    
    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "createDate", ascending: true)

        tableView.reloadData()
    }


}

//MARK: - Search Bar Methods
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createDate", ascending: true).sorted(byKeyPath: "done", ascending: false)
        tableView.reloadData()
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
