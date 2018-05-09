//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Ankur Badola on 5/8/18.
//  Copyright © 2018 Ankur Badola. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {
    
    var catagories = [Catogeory]()
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

  
    
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = catagories[indexPath.row].name
        return cell
    }
    
  
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
       if let indexPath = tableView.indexPathForSelectedRow {
        destinationVC.selectedCategory = catagories[indexPath.row]
        }
    }
    
    
     //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Catagory", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newCategory = Catogeory(context: self.context)
            newCategory.name = textField.text!
            self.catagories.append(newCategory)
            self.saveCatagory()
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
    func saveCatagory(){
        do{
            try self.context.save();
        }catch{
            print("Error saving content, \(error)")
        }
        self.tableView.reloadData()
    }

    func loadItems(with request: NSFetchRequest<Catogeory> = Catogeory.fetchRequest()){
        // let request: NSFetchRequest<Item> = Item.fetchRequest()
        do{
            self.catagories = try context.fetch(request)
        }catch {
            print("Error Fetching data from content \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    
}
