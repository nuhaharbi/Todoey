//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Nuha Alharbi on 27/02/2023.
//

import UIKit

class ToDoListViewController: UIViewController {
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var mainCategory: String? {
        willSet {
            title = newValue
        }
    }
    
    // VIEWS
    let cellIdentifire = "ToDoListCell"
    var tableView: UITableView = {
        let tv = UITableView(frame: .zero)
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "ToDoListCell")
        return tv
    }()
    
    var searchField: UITextField = {
        let tf = UITextField(frame: .zero)
        tf.placeholder = "search for item..."
        tf.backgroundColor = .white
        tf.borderStyle = .roundedRect
        tf.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        return tf
    }()
    
    var items = [Item(title: "Go to mall")]
    var filteredItems = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        view.addSubview(searchField)
        view.backgroundColor = .white

        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        searchField.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -12).isActive = true
        
        searchField.addTarget(self, action: #selector(startSearching), for: .editingChanged)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }

    @objc func startSearching(_ sender: UITextField) {
        
        filteredItems.removeAll()
        if sender.text != "" {
            filteredItems = items.filter({ item in
                item.title.lowercased().contains((sender.text?.lowercased())!)
            })
            items = filteredItems
        } else {
            // here we need to fetch the items from the database
            items.append(Item(title: "Go to mall"))
        }
        tableView.reloadData()
    }
    
    //MARK: - Add new item
    
    @objc func addButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add item", message: "Add new item to the list", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Type new item ..."
        }
        
        let cancelActon = UIAlertAction(title: "Cancel", style: .cancel)
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let item = alert.textFields?[0].text {
                let newItem = Item(title: item)
                self.items.append(newItem)
                self.tableView.reloadData()
            }
        }

        alert.addAction(addAction)
        alert.addAction(cancelActon)
        present(alert, animated: true)
    }
}

//MARK: - TableViewDelegate

extension ToDoListViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].isChecked.toggle()
        tableView.reloadData()
    }
    
}

// MARK: - Table view data source

extension ToDoListViewController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        cell.accessoryType = items[indexPath.row].isChecked ? .checkmark : .none

        return cell
    }
}

