//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Nuha Alharbi on 27/02/2023.
//

import UIKit
import RealmSwift

class ToDoListViewController: UIViewController {

    //MARK: - UIViews
    
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
    
    //MARK: - Vars
    
    let cellIdentifire = "ToDoListCell"
    let realm = try! Realm()
    var items : Results<ToDoItem>?
    var mainCategory: ToDoCategory? {
        didSet {
            fetchItems()
            title = mainCategory?.title
        }
    }
    
    //MARK: - App lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()

    }
    
    //MARK: - Setup view
    
    func setUpView() {
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

    //MARK: - Search textfield
    
    @objc func startSearching(_ sender: UITextField) {
        fetchItems()
        if sender.text != "" {
            items = items?.filter("title CONTAINS[c] %@", sender.text!).sorted(byKeyPath: "dateCrated", ascending: true)
        }
        tableView.reloadData()
    }
    
    //MARK: - Database opreations
    
    func saveItems(_ newItem: ToDoItem) {
        do{
            try self.realm.write {
                self.mainCategory?.items.append(newItem)
            }
        } catch {
            print("Unable to save item")
        }
        
        self.tableView.reloadData()
    }
    
    func updateItems(_ selectedItem: ToDoItem) {
        do {
            try realm.write {
                selectedItem.isChecked.toggle()
            }
        } catch {
            print("Unable to update item")
        }
        
        tableView.reloadData()
    }

    
    func fetchItems() {
        items = mainCategory?.items.sorted(byKeyPath: "title", ascending: true)
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
                let newItem = ToDoItem(title: item, isChecked: false)
                
                self.saveItems(newItem)
            }
        }

        alert.addAction(addAction)
        alert.addAction(cancelActon)
        present(alert, animated: true)
    }
}

//MARK: - Table View Delegate

extension ToDoListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedItem = items?[indexPath.row] {
            updateItems(selectedItem)
        }
    }
}

// MARK: - Table view data source

extension ToDoListViewController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isChecked ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added to the list"
        }

        return cell
    }
}

