//
//  ViewController.swift
//  ToDo
//
//  Created by Ankur Badola on 5/2/18.
//  Copyright © 2018 Ankur Badola. All rights reserved.
//

import UIKit
import CoreData
class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory: Catogeory?{
        didSet{
         loadItems()
        }
    }
   // let defaults = UserDefaults.standard
//     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
//       
//        
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demogorgon"
//        itemArray.append(newItem3)
        
        
   // loadItems()
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if(item.done == true){
//             cell.accessoryType = .checkmark
//        }else{
//             cell.accessoryType = .none
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // let indexpath = itemArray[indexPath.row]
       // print("indexpath:\(indexpath)")
        
//          context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        if (itemArray[indexPath.row].done == false){
//            itemArray[indexPath.row].done = true
//        }else{
//            itemArray[indexPath.row].done = false
//        }
//
        self.saveItems()
        tableView.reloadData()
        
//        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//            //print("indexpath:\(indexpath)")
//        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will hapn one the use click
            //print(textField.text!)
           
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCatagory = self.selectedCategory
            self.itemArray.append(newItem)
           // self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
           self.saveItems()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField(configurationHandler: { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveItems(){
       
        do{
           try self.context.save();
        }catch{
            print("Error saving content, \(error)")
        }
        self.tableView.reloadData()
    }
    
//    func loadItems(){
//      if let data = try? Data(contentsOf: dataFilePath!){
//            let decoder = PropertyListDecoder()
//        do{
//            itemArray = try decoder.decode([Item].self, from: data )
//        }catch{
//            print("Error decoding item array, \(error)")
//        }
//
//        }
//    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
       // let request: NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCatagory.name MATCHES %@", selectedCategory!.name!)
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
//        request.predicate = compoundPredicate
        
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
        }catch {
            print("Error Fetching data from content \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
   
}

//MARK: - Search Bar Methods
extension ToDoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request,predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}



