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
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
        
        if password != confPassword {
            showAlert(title: "Wrong password confirmation", message: "Password and confirm password must be same")
            return
        }
        
        if checkIfEmailExists(email: email) {
            showAlert(title: "Email already taken", message: "This email already taken by other user")
            return
        }
        
        // Pass all validation
        saveUserToCoreData(name: name, email: email, password: password)
    }
    
    func checkIfEmailExists(email: String) -> Bool {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let users = try context.fetch(fetchRequest)
            return !users.isEmpty
        } catch {
            showAlert(title: "Error", message: "Failed to fetch user data.")
            return true
        }
    }
    
    func saveUserToCoreData(name: String, email: String, password: String) {
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)!
        let newUser = NSManagedObject(entity: entity, insertInto: context)
        newUser.setValue(name, forKey: "name")
        newUser.setValue(email, forKey: "email")
        newUser.setValue(password, forKey: "password")
        newUser.setValue("user", forKey: "role")
        newUser.setValue(2000000, forKey: "balance")
        
        do {
            try context.save()
            
            if let nextPage = storyboard?.instantiateViewController(withIdentifier: "loginView") as? LoginViewController {
                self.navigationController?.pushViewController(nextPage, animated: true)
                showAlert(title: "Registration Successful", message: "You can login using you account now")
            }
        } catch {
            showAlert(title: "Error", message: "Failed to save user data.")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
