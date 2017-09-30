//
//  NotesViewController.swift
//  SimpleNote
//
//  Created by ParaBellum on 9/29/17.
//  Copyright © 2017 ParaBellum. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {
    //MARK: Properties
    fileprivate let cellID = "NoteCell"
    fileprivate let segueID = "AddNewNote"
    
    var managedObjectContext = CoreDataManager.instance.managedObjectContext
    
    fileprivate lazy var fetchedResultController: NSFetchedResultsController<Note> = {
        let fetchRequest:NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:self.managedObjectContext, sectionNameKeyPath:  nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchData()
    }
    
    
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID{
            let addNoteVC = segue.destination as! AddNewNoteViewController
            addNoteVC.moc = self.managedObjectContext
        }
    }
    
    //MARK: Funcs
    fileprivate func configureTableView(){
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
    fileprivate func fetchData() {
        do{
            try fetchedResultController.performFetch()
        } catch{
            fatalError("Error fetching Notes")
        }
    }
}

extension NotesViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections!.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultController.sections?[section] else {fatalError("Unexpected Section")}
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NoteTableViewCell
        let note = fetchedResultController.object(at: indexPath)
        cell.configure(with: note)
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let note = fetchedResultController.object(at: indexPath)
            managedObjectContext.delete(note)
            CoreDataManager.instance.saveContext()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

extension NotesViewController: NSFetchedResultsControllerDelegate{
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
