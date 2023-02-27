//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Nuha Alharbi on 27/02/2023.
//

import UIKit

class CategoryViewController: UITableViewController {

    var categoryArray = ["Grocery", "Shopping", "Homework"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryCell")
        title = "Todoey"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    //MARK: - Add new item
    
    @objc func addButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add category", message: "Add new category", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Type new category ..."
        }
        
        let cancelActon = UIAlertAction(title: "Cancel", style: .cancel)
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let category = alert.textFields?[0].text {
                self.categoryArray.append(category)
                self.tableView.reloadData()
            }
        }

        alert.addAction(addAction)
        alert.addAction(cancelActon)
        present(alert, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row]

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let destenationVC = ToDoListViewController()
        destenationVC.mainCategory = categoryArray[indexPath.row]
        navigationController?.pushViewController(destenationVC , animated: true)
    }

}
