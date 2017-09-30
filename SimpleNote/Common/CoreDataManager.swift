//
//  CoreDataManager.swift
//  BeStrong!
//
//  Created by ParaBellum on 4/3/17.
//  Copyright © 2017 ParaBellumProd. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager{
    static let instance = CoreDataManager()
    private init(){}
    
    
    func entityForName(entityName: String) -> NSEntityDescription{
        return NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)!
    }
    
    //FetchedResultController for entity name
    func fetchedResultsController(entityName: String, keyForSort: String) -> NSFetchedResultsController<NSFetchRequestResult>{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: keyForSort, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }

    
    //CoreData STACK!
    lazy var managedObjectContext: NSManagedObjectContext = self.persistentContainer.viewContext
    lazy var persistentContainer: NSPersistentContainer = {
                let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            if let error = error as NSError? {
                                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
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
    
    

}
