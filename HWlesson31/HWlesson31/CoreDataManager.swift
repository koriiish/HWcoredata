//
//  CoreDataManager.swift
//  HWlesson31
//
//  Created by Карина Дьячина on 7.04.24.
//

import Foundation
import CoreData

class CoreDataManager {
    
    private init() { }
    private let queue = DispatchQueue(label: "CoreData")
    static let shared = CoreDataManager()
    
    lazy var cars: [Car] = {
        let managedContext = self.persistentContainer.viewContext
        
        guard let results = try? managedContext.fetch(NSFetchRequest(entityName: "Car")) as? [Car] else { return [] }
        
        return results
    }()
    
    // MARK: - Database modification methods
    func save(brand: String, model: String, color: String, year: String, completion: @escaping (NSManagedObject) -> ()) {
        
        let managedContext = self.persistentContainer.viewContext
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Car",
                                                                 in: managedContext) else { return } 
        let car = Car(entity: entityDescription, insertInto: managedContext)
        
        car.brand = brand
        car.model = model
        car.color = color
        car.year = year
        
        self.saveContext()
        self.cars.append(car)
        
        completion(car)
    }
    
    func readBrand(at index: Int) -> String {
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
        do {
            let results = try managedContext.fetch(fetchRequest)
            let resultObject = results[index] as! Car
            return resultObject.brand ?? "I dont know brand"
        } catch {
            return(error.localizedDescription)
        }
    }
    
    func readModel(at index: Int) -> String {
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
        do {
            let results = try managedContext.fetch(fetchRequest)
            let resultObject = results[index] as! Car
            return resultObject.model ?? "I dont know model"
        } catch {
            return(error.localizedDescription)
        }
    }
    func readColor(at index: Int) -> String {
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
        do {
            let results = try managedContext.fetch(fetchRequest)
            let resultObject = results[index] as! Car
            return resultObject.color ?? "I dont know color "
        } catch {
            return(error.localizedDescription)
        }
    }
    
    func readYear(at index: Int) -> String {
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
        do {
            let results = try managedContext.fetch(fetchRequest)
            let resultObject = results[index] as! Car
            return resultObject.year ?? "I dont know year"
        } catch {
            return(error.localizedDescription)
        }
    }
    func delete(at index: Int, completion: @escaping () -> ()) {
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            let resultObject = results[index] as! Car
            managedContext.delete(resultObject)
            
        } catch {
            completion()
        }
        
        self.saveContext()
    }
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "HWlesson31")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support

        func saveContext () {
            queue.async {
                let context = self.persistentContainer.viewContext
                if context.hasChanges {
                    do {
                        try context.save()
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        let nserror = error as NSError
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                }
            }
        }

    }
