//
//  ViewController.swift
//  IniNotesV3
//
//  Created by IndratS on 23/09/20.
//  Copyright © 2020 IndratSaputra. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
    @IBOutlet weak var mySearch: UISearchBar!
    @IBOutlet weak var myTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let util = Utilities()
    let op = Operations()
    var items: [Notes]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotes()
        
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    func getNotifCreate(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshData), name: NSNotification.Name(rawValue: "createDataNotif"), object: nil)
    }
    
    @objc func refreshData() {
        loadNotes()
    }
    
    func loadNotes(){
        self.items = op.loadData()
        
        DispatchQueue.main.async {
            self.myTableView.reloadData()
        }
    }
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: util.segueNote, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == util.segueNote) {
            
        }
    }
}


extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        let note = self.items?[indexPath.row]
        
        cell.textLabel?.text = note?.title ?? "Unknow"
        
        return cell
    }
    
    
    
    
}


