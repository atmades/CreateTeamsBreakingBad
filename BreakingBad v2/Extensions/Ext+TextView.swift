//
//  Ext+TextView.swift
//  BreakingBad v2
//
//  Created by Максим on 07/12/2021.
//

import UIKit

extension UITextView {
    //    MARK: - Add Done Button to Keyboard
    func setupDoneButton() {
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
    @objc
    func doneButtonAction() {
       self.endEditing(true)
    }
}
