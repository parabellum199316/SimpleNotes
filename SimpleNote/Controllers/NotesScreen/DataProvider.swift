//
//  DataProvider.swift
//  SimpleNote
//
//  Created by ParaBellum on 9/30/17.
//  Copyright © 2017 ParaBellum. All rights reserved.
//

import UIKit
import CoreData
class DataProvider:NSObject,UITableViewDelegate,UITableViewDataSource{
    //MARK: Properties
    var moc:NSManagedObjectContext!
    weak var tableView:UITableView!
    fileprivate let cellID = "NoteCell"
    fileprivate lazy var fetchedResultController: NSFetchedResultsController<Note> = {
        let fetchRequest:NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:self.moc, sectionNameKeyPath:  nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    //MARK: Init
    convenience init(_ moc:NSManagedObjectContext,tableView:UITableView){
        self.init()
        self.moc = moc
        self.tableView = tableView
        configureTableView()
        fetchData()
    }
  
    //MARK:Funcs
    fileprivate func configureTableView(){
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
    func fetchData() {
        do{
            try fetchedResultController.performFetch()
        } catch{
            fatalError("Error fetching Notes")
        }
    }
    //MARK: TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return fetchedResultController.sections!.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultController.sections?[section] else {fatalError("Unexpected Section")}
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NoteTableViewCell
        configureCell(for: cell, at: indexPath)
        return cell
    }
    func configureCell(for cell:NoteTableViewCell , at indexPath: IndexPath){
        let note = fetchedResultController.object(at: indexPath)
        cell.configure(with: note)
    }
    //Delegate
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let note = fetchedResultController.object(at: indexPath)
            moc.delete(note)
            CoreDataManager.instance.saveContext()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
extension DataProvider: NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .update: break
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .update:
            break
        case .move:
            break
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

