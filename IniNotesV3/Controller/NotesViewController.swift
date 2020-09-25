//
//  ViewController.swift
//  IniNotesV3
//
//  Created by IndratS on 23/09/20.
//  Copyright © 2020 IndratSaputra. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {
    @IBOutlet weak var mySearch: UISearchBar!
    @IBOutlet weak var myTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let util = Utilities()
    let op = Operations()
    var items: [Notes]?
    var indexP: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotes()
        getNotifCreate()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        mySearch.delegate = self
    }
    
    
    func getNotifCreate(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshData), name: NSNotification.Name(rawValue: "createDataNotif"), object: nil)
    }
    
    @objc func refreshData() {
        loadNotes()
    }
    
    // MARK: LOAD DATA
    func loadNotes(){
        self.items = op.loadData()
        DispatchQueue.main.async {
            self.myTableView.reloadData()
        }
    }
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        self.indexP = nil
        performSegue(withIdentifier: util.segueNote, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == util.segueNote) {
            let controller = segue.destination as? OperationViewController
            controller?.indexP = self.indexP
        }

    }
}


extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    // GET NUMBER OF ROW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        let note = self.items?[indexPath.row]
        
        cell.textLabel?.text = note?.title ?? "Unknow"
        
        return cell
    }
    
    // MARK: DELETE DATA
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete", handler: {(action, view, completionHandler) in
            let data = self.items![indexPath.row]

            let alert = UIAlertController.showAlertDelete {
                self.op.context.delete(data)
                do {
                    try self.op.context.save()
                }catch{
                    print("Error Delete")
                }
                
                self.loadNotes()
            }
            self.present(alert, animated: true)
        })
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexP = indexPath.row
        
        performSegue(withIdentifier: util.segueNote, sender: indexPath)
    }
    
    
}

extension NotesViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print(mySearch.text)
//    }
    // MARK: SEARCH DATA
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Notes> = Notes.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", mySearch.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        do {
            items = try context.fetch(request)
        }catch{
            print("error search")
        }
        myTableView.reloadData()
    }
    
    // MARK: DEFAULT SEARCH DATA
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if mySearch.text?.count == 0 {
            loadNotes()
        }
    }
}

