//
//  OperationViewController.swift
//  IniNotesV3
//
//  Created by IndratS on 23/09/20.
//  Copyright © 2020 IndratSaputra. All rights reserved.
//

import UIKit
import CoreData

class OperationViewController: UIViewController {
    @IBOutlet weak var label01: UILabel!
    @IBOutlet weak var textField01: UITextField!
    @IBOutlet weak var label02: UILabel!
    @IBOutlet weak var textviewd02: UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let validation = Validation()
    let op = Operations()
    let util = Utilities()
    var items: [Notes]?
    var indexP: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//            indexP = nil
        self.items = op.loadData()
        load()
    }
    
    func load(){
        let data = items![indexP!]
        textField01.text = data.title
        textviewd02.text = data.descriptionNote
    }
    
    private func checkingNote(indexP: Int?) -> Int?{
        var data: Int?
        if indexP == nil {
            data = nil
        }else{
            data = indexP
        }
        return data
    }
    
    // MARK: SAVE DATA
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        let data = checkingNote(indexP: self.indexP)
        switch data {
        case .none:
            //processSave()
            print("proses save")
        case .some(let data) :
            processEdit(index: data)
            
        }
    }
    
    private func processEdit(index: Int){
        print("index : \(index)")
        self.items = op.loadData()
        
        
        guard let title = textField01.text else {return}
        guard let descriptionNote = textviewd02.text else {return}
        
        let check = validation.validateTextfield(title: title, description: descriptionNote)
        
        if check {
//            print("update berhasil")
            let person = items![index]
            person.title = title
            person.descriptionNote = descriptionNote
            person.modifDate = Date()
            do {
                try op.context.save()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "createDataNotif"), object: nil)
                goBack()
            }catch{
                print("Error : \(error) ")
            }
        }else{
            let alert = UIAlertController.showAlert(message: "Minimal Judul atau Deskripsi \(util.minText) huruf", titleAction: "OK")
            self.present(alert, animated: true)
        }
        
    }
    
    
    private func processSave(){
        guard let title = textField01.text else {return}
        guard let descriptionNote = textviewd02.text else {return}
        
        // cek ada yang
        let check = validation.validateTextfield(title: title, description: descriptionNote)
        
        if check == false {
            // GAGAL
            let alert = util.showAlert(message: "Minimal Judul atau Deskripsi \(util.minText) huruf", titleAction: "OK")
            self.present(alert, animated: true)
            
        }else{
            // data OK
            let note = Notes(context: context)
            note.title = title
            note.descriptionNote = descriptionNote
            note.addDate = Date()
            
            // save
            do {
                try context.save()
                DispatchQueue.main.async {
                    let alert = UIAlertController.showAlertSuccess {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "createDataNotif"), object: nil)
                        self.goBack()
                    }
                    self.present(alert, animated: true)
                }
            }catch{
                //                print(err)
                let alert = util.showAlert(message: "Error Simpan Data", titleAction: "OK")
                self.present(alert, animated: true)
            }
        }
    }
    
    
}


extension OperationViewController {
    private func goBack(){
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
