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
    let util = Utilities()
    var items: [Notes]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func getDataText(){
        
    }
    
    
    
    
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
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

                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "createDataNotif"), object: nil)
//                DispatchQueue.main.async {
//                    let alert = UIAlertController.showAlertSuccess {
//                        self.goBack()
//
//                    }
//                    self.present(alert, animated: true)
//                }
            }catch let err{
                print(err)
                let alert = util.showAlert(message: "Error Simpan Data", titleAction: "OK")
                self.present(alert, animated: true)
            }
        }
        goBack()
    }
    
    
    func goBack(){
       navigationController?.popViewController(animated: true)
       dismiss(animated: true, completion: nil)
    }
    
    
}
