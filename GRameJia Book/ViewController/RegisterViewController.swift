//
//  RegisterViewController.swift
//  GRameJia Book
//
//  Created by prk on 7/24/24.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController {
    
    var context: NSManagedObjectContext!

    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        context = appDelegate.persistentContainer.viewContext
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var confPassField: UITextField!
    
    @IBAction func onRegisterBtnClick(_ sender: Any) {
        
        guard let name = nameField.text, !name.isEmpty else {
            showAlert(title:"Name is empty", message: "Name must not be empty.")
            return
        }
        
        guard let email = emailField.text, !email.isEmpty else {
            showAlert(title:"Email is empty", message: "Email must not be empty.")
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            showAlert(title:"Password is empty", message: "Password must not be empty.")
            return
        }
        
        guard let confPassword = confPassField.text, !confPassword.isEmpty else {
            showAlert(title:"Confirm password is empty", message: "Confirm password must not be empty.")
            return
        }
        
        guard let email = emailField.text, email.hasSuffix(".com") && email.contains("@") else {
            showAlert(title: "Email must be valid", message: "Email must contain '@' and ends with \".com\"")
            return
        }
        
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
