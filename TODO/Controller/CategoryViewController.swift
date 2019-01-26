//
//  CategoryViewController.swift
//  TODO
//
//  Created by fengwei on 2019/1/18.
//  Copyright © 2019 fengwei. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = [Cate]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell",for:indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue:UIStoryboardSegue,sender:Any?){
        let destinationVC = segue.destination as! TodoListViewController
        if segue.identifier == "goToItems"{
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory = categories[indexPath.row]
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert=UIAlertController(title: "添加新的类别", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "添加", style: .default){
            (action) in
            let newCategory = Cate(context:self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            self.saveCategories()
        }
        alert.addAction(action)
        alert.addTextField{
            (field)in
            textField = field
            textField.placeholder = "添加一个新的类别"
            
        }
        present(alert,animated: true,completion: nil)
    }
    
    func saveCategories(){
        do{
            try context.save()
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    func loadCategories(){
        let request:NSFetchRequest<Cate> = Cate.fetchRequest()
        do{
            categories = try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }

    

}
