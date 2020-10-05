//
//  OperationViewController.swift
//  IniNotesV3
//
//  Created by IndratS on 23/09/20.
//  Copyright © 2020 IndratSaputra. All rights reserved.
//

import UIKit
import CoreData
import NotificationCenter

class OperationViewController: UIViewController {
    @IBOutlet weak var label01: UILabel!
    @IBOutlet weak var textField01: UITextField!
    @IBOutlet weak var label02: UILabel!
    @IBOutlet weak var textviewd02: UITextView!
    @IBOutlet weak var mySwitch: UISwitch!
    @IBOutlet weak var myDate: UIDatePicker!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let validation = Validation()
    let op = Operations()
    let util = Utilities()
    var items: [Notes]?
    var indexP: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.items = op.loadData()
        load()
        loadUI()
        mySwitch.isOn = false
        
    }
    
    
    @IBAction func mySwitchChange(_ sender: UISwitch) {
        if sender.isOn == true {
            print("jali on")
            myDate.isHidden = false
            
            
        }else if sender.isOn == false {
            print("false")
            myDate.isHidden = true
        }
    }
    
    func setNotificationNotes(){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) {(granted, error) in
        }
        let content = UNMutableNotificationContent()
        content.title = "alert notif"
        content.body = "cek body"
        content.sound = UNNotificationSound.default
        
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: myDate.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        center.add(request) {(error) in
            
        }
        
    }
    
    
    // load data
    private func load(){
        if indexP != nil {
            let data = items![indexP!]
            textField01.text = data.title
            textviewd02.text = data.descriptionNote
        }
        
    }
    
    private func loadUI(){
        textviewd02.layer.cornerRadius = 10
        
        if indexP != nil {
            self.navigationItem.title = "Edit Form"
        }else{
            self.navigationItem.title = "Create New"
        }
        
    }
    
    // GET INDEX
    private func checkingNote(indexP: Int?) -> Int?{
        var data: Int?
        if indexP == nil {
            data = nil
        }else{
            data = indexP
        }
        return data
    }
    
    // MARK: CHECKING NOTE
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        setNotificationNotes()
//        let data = checkingNote(indexP: self.indexP)
//        switch data {
//        case .none:
//            processSave()
//            print("lets to proccess save")
//        case .some(let data) :
//            processEdit(index: data)
//            print("lets to proccess edit")
//        }
    }
    
    
    //  MARK: PROCESS UPDATE
    private func processEdit(index: Int){
        print("index : \(index)")
        self.items = op.loadData()
        
        guard let title = textField01.text else {return}
        guard let descriptionNote = textviewd02.text else {return}
        
        let check = validation.validateTextfield(title: title, description: descriptionNote)
        if check {
            let person = items![index]
            person.title = title
            person.descriptionNote = descriptionNote
            person.modifDate = Date()
            do {
                try op.context.save()
                DispatchQueue.main.async {
                    let alert = UIAlertController.showAlertSuccess {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "createDataNotif"), object: nil)
                        self.goBack()
                    }
                    self.present(alert, animated: true)
                }
                
            }catch{
                print("Error : \(error) ")
            }
        }else{
            let alert = UIAlertController.showAlert(message: "Minimal Judul atau Deskripsi \(util.minText) huruf", titleAction: "OK")
            self.present(alert, animated: true)
        }
        
    }
    
    
    // MARK: PROCESS SAVE
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

