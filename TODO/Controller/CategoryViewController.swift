//
//  CategoryViewController.swift
//  TODO
//
//  Created by fengwei on 2019/1/18.
//  Copyright © 2019 fengwei. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    var categories:Results<Cate>?
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell",for:indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "没有任何的类别"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue:UIStoryboardSegue,sender:Any?){
        let destinationVC = segue.destination as! TodoListViewController
        if segue.identifier == "goToItems"{
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert=UIAlertController(title: "添加新的类别", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "添加", style: .default){
            (action) in
            let newCategory = Cate()
            newCategory.name = textField.text!
            //self.categories.append(newCategory)
            self.saveCategories(cate:newCategory)
        }
        alert.addAction(action)
        alert.addTextField{
            (field)in
            textField = field
            textField.placeholder = "添加一个新的类别"
            
        }
        present(alert,animated: true,completion: nil)
    }
    
    func saveCategories(cate:Cate){
        do{
            try realm.write {
                realm.add(cate)
            }
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    func loadCategories(){
        categories = realm.objects(Cate.self)
       
        tableView.reloadData()
    }

    

}
