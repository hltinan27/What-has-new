//
//  ContactViewController.swift
//  ProjectForNeyasis
//
//  Created by inan on 22.07.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit
import MessageUI

class ContactViewController: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {
  @IBOutlet weak var scrollView: UIScrollView!
 
  @IBOutlet weak var nameTextField: UITextField!
  
  @IBOutlet weak var emailTextField: UITextField!
  
  @IBOutlet weak var birthDayTextField: UITextField!
  @IBOutlet weak var phoneTextField: UITextField!
 
  let composeVC = MFMailComposeViewController()
  
  override func viewDidLoad() {
        super.viewDidLoad()
    self.navigationItem.title = "Contact"
    
    //Move to keyboard
    NotificationCenter.default.addObserver(self, selector: #selector(keyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(keyboard), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    
    // MARK: Email
    composeVC.mailComposeDelegate = self
    
    if !MFMailComposeViewController.canSendMail() {
      print("Mail services are not available")
      alertMessage(title: "Warning", message: "Mail services are not available")
      return
    }
  }
  
  @IBAction func sendEmailAction(_ sender: UIBarButtonItem) {
    if nameTextField.text != "" && phoneTextField.text != "" && birthDayTextField.text != "" {
      composeVC.setToRecipients(["gokhan.gokova@neyasis.com "])
      composeVC.setSubject("I hope everything goes right")
      composeVC.setMessageBody("I hope everything goes right \n \(nameTextField.text!)  \n \(phoneTextField.text!)  \n \(birthDayTextField.text!)!", isHTML: false)
      
      // Present the view controller modally.
      self.present(composeVC, animated: true, completion: nil)
    }else{
      alertMessage(title: "Warning", message: "Missing information")
    }
   
  }
  
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    switch result {
    case .cancelled: print("cancel")
    case .failed: print("failed")
    case .saved: print("saved")
    case .sent: print("send")
    default: print("error")
    }
    dismiss(animated: true, completion: nil)
  }


  @objc func keyboard(notification: Notification){
    let userInfo = notification.userInfo
    let keyboardScreenEndFrame = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)

    if notification.name == NSNotification.Name.UIKeyboardWillHide{
      scrollView.contentInset = UIEdgeInsets.zero
    }else{
      scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)

    }
    scrollView.scrollIndicatorInsets = scrollView.contentInset
  }
  
  
  // move to the next UITextField when the user presses return
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField.tag == 3{
      textField.resignFirstResponder()
    }
    
    let nextTag = textField.tag + 1
    
    if let nextResponder = textField.superview?.viewWithTag(nextTag) {
      nextResponder.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }
    
    return true

  }
  
  func alertMessage(title:String, message:String){
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
    alert.addAction(okButton)
    self.present(alert, animated: true, completion: nil)
    
    
  }
  
}


extension UIViewController {
  func hideKeyboard(){
    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tap)
  }

  @objc func dismissKeyboard(){
    view.endEditing(true)
  }
}
