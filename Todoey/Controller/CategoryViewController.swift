//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Nuha Alharbi on 27/02/2023.
//

import UIKit
import RealmSwift
import Realm

class CategoryViewController: UITableViewController {

    //MARK: - Vars
    
    let cellIdentifire = "categoryCell"
    var categoryArray : Results<ToDoCategory>?
    var realm = try! Realm()
    
    //MARK: - App life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchCategories()
        setUpView()
    }
    
    //MARK: - setup view
    
    func setUpView() {
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifire)
        tableView.rowHeight = 80
        title = "Todoey"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
    }
    
    //MARK: - Database opreations
    
    func fetchCategories() {
        categoryArray = realm.objects(ToDoCategory.self)
        self.tableView.reloadData()
    }
    
    func saveCategories(_ category: ToDoCategory) {
        do {
            try self.realm.write {
                self.realm.add(category)
            }
        } catch {
            print("Unable to save category")
        }

        self.tableView.reloadData()
    }
    
    func deleteCategories(_ category: ToDoCategory) {
        do {
            try realm.write({
                realm.delete(category)
            })
        } catch {
            print("Unable to delete category")
        }
    }
    
    //MARK: - Add new item
    
    @objc func addButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add category", message: "Add new category", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Type new category ..."
        }
        
        let cancelActon = UIAlertAction(title: "Cancel", style: .cancel)
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let categoryTitle = alert.textFields?[0].text {
                
                let newCategory = ToDoCategory(title: categoryTitle)
                self.saveCategories(newCategory)
            }
        }

        alert.addAction(addAction)
        alert.addAction(cancelActon)
        present(alert, animated: true)
    }
    
    //MARK: - Update an item
    
    func editButtonPressed(_ category: ToDoCategory) {
        let alert = UIAlertController(title: "Edit category", message: "Edit category title", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = category.title
        }
        
        let cancelActon = UIAlertAction(title: "Cancel", style: .cancel)
        let addAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let newTitle = alert.textFields?[0].text {
                do {
                    try self.realm.write {
                        category.title = newTitle
                    }
                } catch {
                    print("Unable to update category title")
                }
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelActon)
        present(alert, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath)
        if let category = categoryArray?[indexPath.row] {
            cell.textLabel?.text = category.title
        }
        return cell
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let itemsVC = ToDoListViewController()
        itemsVC.mainCategory = categoryArray?[indexPath.row]
        navigationController?.pushViewController(itemsVC , animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let category = categoryArray?[indexPath.row] else { return }
        deleteCategories(category)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            if let category = self.categoryArray?[indexPath.row] {
                self.editButtonPressed(category)
            }
        }
    
        editAction.backgroundColor = .systemBlue
        let configuration = UISwipeActionsConfiguration(actions: [editAction])
        return configuration
    }
}


