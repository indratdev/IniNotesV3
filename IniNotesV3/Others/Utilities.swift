//
//  Utilities.swift
//  IniNotesV3
//
//  Created by IndratS on 23/09/20.
//  Copyright © 2020 IndratSaputra. All rights reserved.
//

import Foundation
import UIKit

struct Utilities {
    let segueNote = "NoteSegue"
    let minText = 3
    
    
    func showAlert(message: String, titleAction: String) -> UIAlertController{
        let alert = UIAlertController(title: "GAGAL", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: titleAction, style: .cancel, handler: nil))
        return alert
    }
    
    func showSuccess(onConfirm: @escaping() -> Void) -> UIAlertController{
        let alert = UIAlertController(title: "Sukses", message: "Data Berhasil Disimpan", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) {_ in onConfirm() }
        alert.addAction(ok)
        return alert
    }
}



