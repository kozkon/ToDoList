//
//  DataStoreManager.swift
//  CD
//
//  Created by Константин Козлов on 23.10.2021.
//

import Foundation
import CoreData
import UIKit

class DataStoreManager{
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CD")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
     
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func deleteTask(task: NSManagedObject){
        
        viewContext.delete(task)
        saveContext()
    }
    
    func fetchData()->([Tasks]) {
        
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            return tasks
        }
        catch let error {
            print(error.localizedDescription)
            let tasks: [Tasks] = []
            return tasks
        }
    }
    
    func saveTextField(with context: NSManagedObjectContext, name: String, date: Date){
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else {return}
        guard let object = NSManagedObject(entity: entity, insertInto: context) as? Tasks else {return}
        object.name = name
        object.date = Date()
        saveContext()
    }
    
    func saveImportantTask(task: Tasks){
       
        task.important = true
        saveContext()
    }
    
 
    
    func deleteImportantTask(taskForDelete: Tasks){
       taskForDelete.important = false
            saveContext()
   }
    
    func saveDetailTask(task: Tasks, image: UIImage, detailDescription: String){
        
        task.image = image.pngData()
        task.detailDescription = detailDescription
        saveContext()
        
    }
}
