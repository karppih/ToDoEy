//
//  CategoryViewController.swift
//  ToDoEy
//
//  Created by Helen Karppi on 12/2/19.
//  Copyright © 2019 Helen Karppi. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Categories.plist")
    let categoryContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        
//        var category = Category()
//        category.name = "Shopping"
//        categoryArray.append(category)
//        category.name = "Kill people"
//        categoryArray.append(category)

        loadCategories()
        loadTable()
    }
    
    func loadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    



//MARK: - Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        print("Top of add category button pressed func")
        var textField = UITextField()
        
        var category = Category(context: self.categoryContext)
        
        let alert = UIAlertController(title: "Add New ToDoEy category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happenwhen the user clicks on the add item button on the UIAlert
            print("UIAlertAction instantiated")
            print(category.name)
            category.name = textField.text!
            self.categoryArray.append(category)
            
            self.saveCategories()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            //            item = Itkjhlkjhem()
            category.name = alertTextField.text!
            textField = alertTextField
            print("Add text field")
            print(category.name)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        print("Add action")
        
    }
    
    //MARK: - TableView DataSourece Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    //MARK: - TalbeView Delegate Methods
//    Leave for later
    
    
    //MARK: - Data Manipulation methods
    
    
    
       func saveCategories() {
        print("Saving categories")
            do {
                try categoryContext.save()
            } catch {
                print("Error saving context \(error)")
            }
            tableView.reloadData()
        }
        
        func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {

    //        let request : NSFetchRequest<Item> = Item.fetchRequest()
            do {
                categoryArray = try categoryContext.fetch(request)
            } catch {
                print("Error fetching data from context \(error)")
            }
            tableView.reloadData()
        }

    
}
