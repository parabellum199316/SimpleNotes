//
//  AddNewNoteViewController.swift
//  SimpleNote
//
//  Created by ParaBellum on 9/30/17.
//  Copyright © 2017 ParaBellum. All rights reserved.
//

import UIKit
import CoreData

class AddNewNoteViewController: UIViewController {
    
    var moc:NSManagedObjectContext!
    var bottomConstraintConstant:CGFloat!
    
    //MARK: Outlets
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextViewX!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    
    @IBAction func saveNote(_ sender: Any) {
        var contentText:String? = contentTextView.text
        if contentTextView.text.isEmpty{
            contentText = nil
        }
        let _ = Note(with: titleTextField.text!, content: contentText, dateAdded:Date())
        do{
            try moc.save()
        }catch{
            fatalError("Failed to save NOTE")
        }
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    
    //MARK:  LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotifications()
        self.saveButton.isEnabled = false
        self.bottomConstraintConstant = keyboardHeightLayoutConstraint.constant
        print(bottomConstraintConstant)
        
    }
   
    
    
    private func registerForNotifications(){
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(textFieldDidChangeText(_:)), name: .UITextFieldTextDidChange, object: nil)
        center.addObserver(self, selector: #selector(keyboardNotification(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
       
    }
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
            let curve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: TimeInterval(duration),
                                       delay: TimeInterval(0),
                                       options: [UIViewAnimationOptions(rawValue: UInt(curve))],
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }


    
    func textFieldDidChangeText(_ notification:Notification){
        self.saveButton.isEnabled = !(self.titleTextField.text?.isEmpty)!
        
    }
    
    deinit {
        let center = NotificationCenter.default
        center.removeObserver(self, name: .UITextFieldTextDidChange, object: nil)
       center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    
    
}
