//
//  CategoryTableVC.swift
//  CoreData_190127
//
//  Created by Joachim Vetter on 29.01.19.
//  Copyright © 2019 Joachim Vetter. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableVC: UITableViewController {

    var myCategories = [Categories]()
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let myAppPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(myAppPath)
        load()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCategories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "myCells", for: indexPath)
        myCell.textLabel?.text = myCategories[indexPath.row].name
        return myCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let myDestinationVC = segue.destination as! MyTableVC
        if let myIndexPath = tableView.indexPathForSelectedRow {
            myDestinationVC.selectedCategory = myCategories[myIndexPath.row]
        }
    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var finalTextField = UITextField()
        
        let myAlertVC = UIAlertController(title: "Add a category", message: "", preferredStyle: .alert)
        let myAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let newCategory = Categories(context: self.myContext)
            newCategory.name = finalTextField.text!
            self.myCategories.append(newCategory)
            self.tableView.reloadData()
            self.save()
        }
        
        myAlertVC.addAction(myAction)
        myAlertVC.addTextField { (myTextField) in
            finalTextField = myTextField
        }
        
        present(myAlertVC, animated: true, completion: nil)
    }
    
    func save() {
        do {
            try myContext.save()
        }
        catch {
            print("error")
        }
    }
    
    func load() {
        let fetching = NSFetchRequest<Categories>(entityName: "Categories")
        do {
            myCategories = try myContext.fetch(fetching)
        }
        catch {
            print("error")
        }
        
    }
}
