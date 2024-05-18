//
//  ViewController.swift
//  HWlesson31
//
//  Created by Карина Дьячина on 6.04.24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var carsArray: [NSManagedObject] = []
    var brandToSave: String = ""
    var modelToSave: String = ""
    var colorToSave: String = ""
    var yearToSave: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigation()
        
        let managedContext =
        CoreDataManager.shared.persistentContainer.viewContext
        
        //2
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "Car")
        
        //3
        do {
            carsArray = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
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
            self.brandToSave = textField.text ?? "brand"
            textField.placeholder = "Brand"
        }
        
        alertController.addTextField { textField in
            self.modelToSave = textField.text ?? "model"
            textField.placeholder = "Model"
        }
        
        alertController.addTextField { textField in
            self.colorToSave = textField.text ?? "color"
            textField.placeholder = "Color"
        }
        
        alertController.addTextField { textField in
            self.yearToSave = textField.text ?? "year"
            textField.placeholder = "Year"
        }
        
//        CoreDataManager.shared.save(brand: brandToSave, model: modelToSave, color: colorToSave, year: yearToSave) {
//            self.tableView.reloadData()
//        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) {_ in
            print("ok")
            guard let textFields = alertController.textFields,
                  textFields.count > 3,
                  let brandToSave = textFields[0].text,
                  let modelToSave = textFields[1].text,
                  let colorToSave = textFields[2].text,
                  let yearToSave = textFields[3].text else {
                return
            }
            self.brandToSave = brandToSave
            self.modelToSave = modelToSave
            self.colorToSave = colorToSave
            self.yearToSave = yearToSave
            
            self.save(name: brandToSave)
        }
        
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    func save(name: String) {
        CoreDataManager.shared.save(brand: brandToSave, model: modelToSave, color: colorToSave, year: yearToSave) { car in
            self.carsArray.append(car)
            self.tableView.reloadData()
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
        //                                            for: indexPath)
        //        cell.textLabel?.text = carsArray[indexPath.row]
        //        return cell
        //
        let car = carsArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath)
        cell.textLabel?.text =
        car.value(forKeyPath: "brand") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if (editingStyle == .delete) {
                CoreDataManager.shared.cars.remove(at: indexPath.row)
                CoreDataManager.shared.delete(at: indexPath.row) {
                    let alert = UIAlertController(title: CoreDataManager.shared.readBrand(at: indexPath.row),
                                                  message: "Can't delete a car.",
                                                  preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true)
                }
                
                tableView.reloadData()
            }
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = """
                Car brand: \(CoreDataManager.shared.readBrand(at: indexPath.row))
                Car model: \(CoreDataManager.shared.readModel(at: indexPath.row))
                Car color: \(CoreDataManager.shared.readColor(at: indexPath.row))
                Car year: \(CoreDataManager.shared.readYear(at: indexPath.row))
                """
                
                let alert = UIAlertController(title: CoreDataManager.shared.readBrand(at: indexPath.row),
                                              message: message,
                                              preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                
                present(alert, animated: true)
            }
    }

