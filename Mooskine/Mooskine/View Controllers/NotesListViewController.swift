//
//  NotesListViewController.swift
//  Mooskine
//
//  Created by Josh Svatek on 2017-05-31.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import CoreData

class NotesListViewController: UIViewController, UITableViewDataSource ,NSFetchedResultsControllerDelegate{
    /// A table view that displays a list of notes for a notebook
    @IBOutlet weak var tableView: UITableView!

    /// The notebook whose notes are being displayed
    var notebook: Notebook!
    
    var fetchedResultController:NSFetchedResultsController<Note>!
    
    
    var dataControler:DataController!

    /// A date formatter for date text in note cells
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()

   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = notebook.name
        navigationItem.rightBarButtonItem = editButtonItem
        
        
        reloadNotes()
        updateEditButtonState()
    }
    
    fileprivate func reloadNotes() {
        let noteFromNoteBookRequest:NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        noteFromNoteBookRequest.sortDescriptors = [sortDescriptor]
        noteFromNoteBookRequest.predicate = NSPredicate(format: "notebook == %@",notebook)
        
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: noteFromNoteBookRequest, managedObjectContext: dataControler.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do{
            try? fetchedResultController.performFetch()
            
        }catch let error{
            fatalError(error.localizedDescription)
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Actions

    @IBAction func addTapped(sender: Any) {
        addNote()
    }

    // -------------------------------------------------------------------------
    // MARK: - Editing

    // Adds a new `Note` to the end of the `notebook`'s `notes` array
    func addNote() {
        
        let note = Note(context: dataControler.viewContext)
        note.attributedText = NSAttributedString(string: "New Note")
        note.creationDate = Date()
        note.notebook = notebook
    try? dataControler.viewContext.save()
       
    }

    // Deletes the `Note` at the specified index path
    func deleteNote(at indexPath: IndexPath) {
        
        let noteToDelete = fetchedResultController.object(at: indexPath)
        dataControler.viewContext.delete(noteToDelete)
        try? dataControler.viewContext.save()
    
    }

    func updateEditButtonState() {
        
        if let sections = fetchedResultController.sections{
            navigationItem.rightBarButtonItem?.isEnabled = sections[0].numberOfObjects > 0
            
        }
        
        
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    // -------------------------------------------------------------------------
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aNote = fetchedResultController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.defaultReuseIdentifier, for: indexPath) as! NoteCell

        // Configure cell
        cell.textPreviewLabel.attributedText = aNote.attributedText
        if let date = aNote.creationDate{
        cell.dateLabel.text = dateFormatter.string(from: date)
        }
        

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteNote(at: indexPath)
        default: () // Unsupported
        }
    }

   

    // -------------------------------------------------------------------------
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If this is a NoteDetailsViewController, we'll configure its `Note`
        // and its delete action
        if let vc = segue.destination as? NoteDetailsViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.note = fetchedResultController.object(at: indexPath)
                vc.dataController = dataControler

                vc.onDelete = { [weak self] in
                    if let indexPath = self?.tableView.indexPathForSelectedRow {
                        self?.deleteNote(at: indexPath)
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}


extension NotesListViewController{
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        default:
            break
        }
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    
    
    
    
}
