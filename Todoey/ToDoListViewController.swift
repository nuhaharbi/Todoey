//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Nuha Alharbi on 26/02/2023.
//

import UIKit

class ToDoListViewController: UITableViewController {

    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var items = ["Buy Eggas", "Workout", "Buy Flowers"]
    let cellIdentifire = "ToDoListCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Todoey"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifire)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath)
        cell.textLabel?.text = items[indexPath.row]

        return cell
    }
    
    //MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType != .checkmark {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        
    }
    
    //MARK: - Add new item
    
    @objc func addButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add item", message: "Add new item to the list", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Type new item ..."
        }
        
        let cancelActon = UIAlertAction(title: "Cancel", style: .cancel)
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let newItem = alert.textFields?[0].text {
                self.items.append(newItem)
                self.tableView.reloadData()
            }
        }

        alert.addAction(addAction)
        alert.addAction(cancelActon)
        present(alert, animated: true)
    }
}
