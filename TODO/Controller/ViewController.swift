//
//  ViewController.swift
//  TODO
//
//  Created by fengwei on 2019/1/13.
//  Copyright © 2019 fengwei. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    //let defaults = UserDefaults.standard
   // var  itemArray = ["购买水杯","吃药","修改密码","a","b","c","d","e","f","g","h","i","j","k","l","m","n"]
    var itemArray = [Item]()
    var selectedCategory:Cate?{
        didSet{
            loadItems()
        }
    }
      //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        //print(234)
      
       // loadItems()
//        for index in 1...120{
//            let newItem = Item()
//            newItem.title = "第\(index)件事务"
//            itemArray.append(newItem)
//        }
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [String]{
//            itemArray = items;
//        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        if itemArray[indexPath.row].done==false{
            cell.accessoryType = .none
        }else{
             cell.accessoryType = .checkmark
        }
        
        return cell;
        
    }
    override func tableView(_ tableView:UITableView,numberOfRowsInSection section:Int)-> Int{
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath)
        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        let title = itemArray[indexPath.row].title
//        itemArray[indexPath.row].setValue(title!+"-(已完成)", forKey: "title")
//        saveItems()
        
        if itemArray[indexPath.row].done==false{
            itemArray[indexPath.row].done=true;
        }else{
            itemArray[indexPath.row].done=false;
        }
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        tableView.endUpdates()
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField();
        let alert = UIAlertController(title: "添加一个新的ToDo项目", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "添加项目", style: .default){
            (action) in
            //let newItem = Item();
            //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let newItem = Item(context: self.context)
            newItem.title = textField.text!;
            newItem.done = false;
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData();
            print(textField.text!)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "创建一个新项目..."
            textField = alertTextField
            
            //print(alertTextField.text!);
            
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    func saveItems(){
        //let encoder = PropertyListEncoder()
        do{
            //let data = try encoder.encode(itemArray)
            //try data.write(to:dataFilePath!)
             //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            try context.save()
            
        }catch{
            print("保存context错误:\(error)");
            //print("编码错误:\(error)");
        }
    }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(),predicate:NSPredicate? = nil){
//        if let data = try? Data(contentsOf: dataFilePath!){
//            let decoder = PropertyListDecoder();
//            do{
//                itemArray = try decoder.decode([Item].self, from: data)
//            }catch{
//                print("解码错误");
//            }
//        }
        //let fetchRequest:NSFetchRequest = NSFetchRequest()
       // let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DataModel");
        //let request:NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let addtionalPredicate = predicate{
             request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addtionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
       
        do{
            itemArray = try context.fetch(request)
        }catch{
            print(error)
        }
    }


}

extension TodoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[c] %@", searchBar.text!)
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do{
            itemArray = try context.fetch(request)
        }catch{
            print(error)
        }
        loadItems(with: request,predicate: predicate)
        //tableView.reloadData()
        print(searchBar.text!)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count==0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
