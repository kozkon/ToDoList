//
//  File.swift
//  CD
//
//  Created by Константин Козлов on 26.10.2021.
//

import UIKit

class UIManager {
   static func okAlert(with title: String, and message: String )->(UIAlertController){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(okAction)
        return ac
    }
}
