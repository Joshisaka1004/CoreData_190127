//
//  ViewController.swift
//  CoreData_190127
//
//  Created by Joachim Vetter on 27.01.19.
//  Copyright © 2019 Joachim Vetter. All rights reserved.
//

import UIKit
import CoreData

class MyTableVC: UITableViewController {

    let myAppPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! //Pfad zum Dateimanager, wo unsere App abgelegt wurde; man benötigt dies, falls man mit SQ-Date manuel was ändern wollen
    
    var myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // Eine Instanz der AppDelegate.swift-Datei wird in Klammern gebildet, um sodann Zugriff auf den Persistent Container zu erhalten; dieser beinhaltet alle Daten von Core Data; auf dessen Attribute können wir aber nur über den Context zugreifen bzw. die Eigenschaft viewContext
    
    var fetchingBySearchBar = NSFetchRequest<Songs>(entityName: "Songs")
    var fetchingByCategory = NSFetchRequest<Songs>(entityName: "Songs")
    
    var selectedCategory: Categories? {
        didSet {
            fetchingByCategory.predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
            load(requestParam: fetchingByCategory)
        }
    }
    
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    var mySongs = [Songs]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mySearchBar.delegate = self
        print(myAppPath)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySongs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        myCell.textLabel?.text = mySongs[indexPath.row].songTitle
        myCell.detailTextLabel?.text = mySongs[indexPath.row].interpret
        if mySongs[indexPath.row].checked {
            myCell.accessoryType = .checkmark
        } else {
            myCell.accessoryType = .none
        }
        return myCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        mySongs[indexPath.row].checked = !mySongs[indexPath.row].checked
        save()
    }
    
    @IBAction func songTitle(_ sender: UIBarButtonItem) {
        
        var finalTextField = UITextField()
        
        let myAlertVC = UIAlertController(title: "Add your song", message: "", preferredStyle: .alert)
        let myAction = UIAlertAction(title: "Done", style: .default) { (myAction) in
            let newSong = Songs(context: self.myContext)
            newSong.songTitle = finalTextField.text!
            newSong.interpret = "???"
            newSong.checked = false
            newSong.parentCategory = self.selectedCategory!
            self.mySongs.append(newSong)
            self.save()
        }
        
        myAlertVC.addAction(myAction)
        myAlertVC.addTextField { (myTextField) in
            finalTextField = myTextField
        }
        
        present(myAlertVC, animated: true, completion: nil)
        
    }
    
    @IBAction func interpret(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func Delete(_ sender: UIBarButtonItem) {
        
    }
    
    func tableReload() {
        tableView.reloadData()
    }
    
    func load(requestParam: NSFetchRequest<Songs> = Songs.fetchRequest()) {
        
        do {
            mySongs = try myContext.fetch(requestParam)
        }
        catch {
            print("error")
        }
        tableReload()
    }
    
    func save() {
        do {
            try myContext.save()
        }
        catch {
            print("error")
        }
        tableReload()
    }
    
}

extension MyTableVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        fetchingBySearchBar.predicate = NSPredicate(format: "songTitle CONTAINS[cd] %@", searchBar.text!)
        fetchingBySearchBar.sortDescriptors = [NSSortDescriptor(key: "songTitle", ascending: true)]
        load(requestParam: fetchingBySearchBar)
        //print(fetching.predicate!)
    }
}
