//
//  ViewController.swift
//  HWlesson31
//
//  Created by Карина Дьячина on 6.04.24.
//

import UIKit

class ViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var carsArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigation()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.reloadData()
    }
    
    func setupNavigation() {
        let addCarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addCarButton
    }
    
    @objc func addButtonTapped() {
        showAlert()
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Add car", message: "Save your favourite cars", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Brand"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Model"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Color"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Year"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) {_ in
            print("ok")
            self.tableView.reloadData()
        }
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
