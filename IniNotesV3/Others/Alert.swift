//
//  Alert.swift
//  IniNotesV3
//
//  Created by IndratS on 24/09/20.
//  Copyright © 2020 IndratSaputra. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    static func showAlertSuccess(onConfirm: @escaping () -> Void) -> UIAlertController {
        let ok = UIAlertAction(title: "OK", style: .default) { _ in onConfirm() }
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        let alert = UIAlertController(title: nil, message: "Sukses", preferredStyle: .alert)
        alert.addAction(ok)
//        alert.addAction(cancel)
        
        return alert
    }
}