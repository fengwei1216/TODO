//
//  ViewController.swift
//  TODO
//
//  Created by fengwei on 2019/1/13.
//  Copyright © 2019 fengwei. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    //let defaults = UserDefaults.standard
   // var  todoItems = ["购买水杯","吃药","修改密码","a","b","c","d","e","f","g","h","i","j","k","l","m","n"]
    var todoItems :Results<Item>?
    let realm = try! Realm()
    var selectedCategory:Cate?{
        didSet{
            loadItems()
        }
    }
      //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
//            todoItems = items;
//        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done==true ? .checkmark : .none
        }else{
            cell.textLabel?.text = "没有事项"
        }
        
        return cell;
        
    }
    override func tableView(_ tableView:UITableView,numberOfRowsInSection section:Int)-> Int{
        return todoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done
                }
            }catch{
                print(error)
            }
        }
        
        tableView.beginUpdates()
       tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
       tableView.endUpdates()
       
       tableView.deselectRow(at: indexPath, animated: true)

        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        let title = itemArray[indexPath.row].title
//        itemArray[indexPath.row].setValue(title!+"-(已完成)", forKey: "title")
//        saveItems()
        
//        if itemArray[indexPath.row].done==false{
//            itemArray[indexPath.row].done=true;
//        }else{
//            itemArray[indexPath.row].done=false;
//        }
//        tableView.beginUpdates()
//        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
//        tableView.endUpdates()
//        saveItems()
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField();
        let alert = UIAlertController(title: "添加一个新的ToDo项目", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "添加项目", style: .default){
            (action) in
            if let currentCate = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item();
                        newItem.title = textField.text!
                        newItem.dataCreated = Date()
                        currentCate.items.append(newItem)
                    }
                }catch{
                    print(error)
                }
            }
            
            
            self.tableView.reloadData();
            //print(textField.text!)
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
       
    }
    
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated",ascending: false)
        tableView.reloadData()
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
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        if let addtionalPredicate = predicate{
//             request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addtionalPredicate])
//        }else{
//            request.predicate = categoryPredicate
//        }
//
//
//        do{
//            itemArray = try context.fetch(request)
//        }catch{
//            print(error)
//        }
    }


}

extension TodoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[c] %@", searchBar.text!).sorted(byKeyPath: "title",ascending: true)
        
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
