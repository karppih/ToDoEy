//
//  CategoryViewController.swift
//  ToDoEy
//
//  Created by Helen Karppi on 12/5/19.
//  Copyright © 2019 Helen Karppi. All rights reserved.
//

import UIKit
import CoreData

//Goal: list of categories that displays and

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
   
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
        print("\(categoryArray.count) categories.")
        
        loadCategories()
        loadTable()
        print("\(categoryArray.count) categories.")

        
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
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    //MARK: - TableView Delgate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        var category = Category(context: context)
        
        //Create alert popup
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            category.name = textField.text!
            self.categoryArray.append(category)
            
            self.saveCategories()
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
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
    
}
