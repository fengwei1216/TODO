//
//  ViewController.swift
//  TODO
//
//  Created by fengwei on 2019/1/13.
//  Copyright © 2019 fengwei. All rights reserved.
//

import UIKit


class TodoListViewController: UITableViewController {

    //let defaults = UserDefaults.standard
   // var  itemArray = ["购买水杯","吃药","修改密码","a","b","c","d","e","f","g","h","i","j","k","l","m","n"]
    var itemArray = [Item]()
      let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        print(dataFilePath as Any)
        
        loadItems()
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
        print(indexPath)
        
        
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
            let newItem = Item();
            newItem.title = textField.text!;
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
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to:dataFilePath!)
        }catch{
            print("编码错误:\(error)");
        }
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder();
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("解码错误");
            }
        }
    }


}

