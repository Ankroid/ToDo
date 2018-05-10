//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Ankur Badola on 5/8/18.
//  Copyright © 2018 Ankur Badola. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var catagories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = catagories?[indexPath.row].name ?? "No Category added"
        return cell
    }
    
  
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
       if let indexPath = tableView.indexPathForSelectedRow {
        destinationVC.selectedCategory = catagories?[indexPath.row]
        }
    }
    
    
     //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Catagory", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           // let newCategory = Catogeory(context: self.context)
            let newCategory = Category()
            newCategory.name = textField.text!
            //self.catagories.append(newCategory)
            self.save(category: newCategory)
            //self.tableView.reloadData()
        }
        
        alert.addTextField(configurationHandler: { (alertTextField) in
            alertTextField.placeholder = "Create New Catagory"
            textField = alertTextField
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            };
        }catch{
            print("Error saving content, \(error)")
        }
        self.tableView.reloadData()
    }

    func loadCategories(){
      catagories = realm.objects(Category.self)
        tableView.reloadData()
    }

    
    
}
