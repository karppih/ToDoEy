//
//  CategoryViewController.swift
//  ToDoEy
//
//  Created by Helen Karppi on 12/5/19.
//  Copyright © 2019 Helen Karppi. All rights reserved.
//

import UIKit
import RealmSwift

//Goal: list of categories that displays and

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
   
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        
//        let titleList = ["Shopping", "Cleaning"]
//        for newTitle in titleList {
//            var newCat = Category(context: context)
//            newCat.name = newTitle
//            categoryArray.append(newCat)
//        }
//        print("\(categories.count) categories.")
        
        loadCategories()
        loadTable()
//        print("\(categories.count) categories.")

        
    }
    
    func loadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - TableView Data Source methods
    //    So we can display categories
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories?[indexPath.row]
        
        cell.textLabel?.text = category?.name ?? "No categories added yet"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    //MARK: - TableView Delgate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        var category = Category()
        
        //Create alert popup
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            category.name = textField.text!
            
            self.save(category: category)
        }
        
        //Add text field to alert popup
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            //            let item = Item(context: self.context)
            category.name = alertTextField.text!
            textField = alertTextField
            print("Add text field")
            print(category.name)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    
    //MARK: - Data Manipulation
    //Save and load data
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
        }
    
    
    
    
}
