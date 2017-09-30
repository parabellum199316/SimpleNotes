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
    var managedObjectContext = CoreDataManager.instance.managedObjectContext
    
    fileprivate let segueID = "AddNewNote"
    var dataProvider:DataProvider!
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataProvider()
        dataProvider.fetchData()
        
    }
    
    
    fileprivate func configureDataProvider() {
        dataProvider = DataProvider(managedObjectContext,tableView: tableView)
        tableView.delegate = dataProvider
        tableView.dataSource = dataProvider
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID{
            let addNoteVC = segue.destination as! AddNewNoteViewController
            addNoteVC.moc = self.managedObjectContext
        }
    }
}




