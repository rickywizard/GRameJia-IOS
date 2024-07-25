//
//  LoginViewController.swift
//  GRameJia Book
//
//  Created by prk on 7/24/24.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    var context: NSManagedObjectContext!

    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        context = appDelegate.persistentContainer.viewContext
        
        initDummy()
    }
    
    func initDummy() {
        do {
            let entityTarget = NSEntityDescription.entity(forEntityName: "User", in: context)
            if let entity = entityTarget {
                // User pertama
                let newUser1 = NSManagedObject(entity: entity, insertInto: context)
                newUser1.setValue("admin@gmail.com", forKey: "email")
                newUser1.setValue("Admin", forKey: "name")
                newUser1.setValue("admin123", forKey: "password")
                newUser1.setValue("admin", forKey: "role")
                newUser1.setValue(0, forKey: "balance")
                
                // User kedua
                let newUser2 = NSManagedObject(entity: entity, insertInto: context)
                newUser2.setValue("tes@gmail.com", forKey: "email")
                newUser2.setValue("Tes", forKey: "name")
                newUser2.setValue("tes123", forKey: "password")
                newUser2.setValue("user", forKey: "role")
                newUser2.setValue(2000000, forKey: "balance")
                
                try context.save()
            } else {
                showAlert(title: "Error", message: "Entity description not found.")
            }
        } catch {
            showAlert(title: "Error", message: "Failed to reset dummy data.")
        }
    }
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func onLoginBtnClick(_ sender: Any) {
        
        guard let email = emailField.text, !email.isEmpty else {
            showAlert(title:"Email is empty", message: "Email must not be empty.")
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            showAlert(title:"Password is empty", message: "Password must not be empty.")
            return
        }
        
        guard let email = emailField.text, email.hasSuffix(".com") && email.contains("@") else {
            showAlert(title: "Email must be valid", message: "Email must contain '@' and ends with \".com\"")
            return
        }
        
        // auth
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
                
        do {
            let users = try context.fetch(fetchRequest)
                    
            if let user = users.first {
                // Perform segue or transition to next screen when login success
                if user.role == "admin" {
                    if let nextPage = storyboard?.instantiateViewController(withIdentifier: "adminView") as? AdminViewController {
                        self.navigationController?.pushViewController(nextPage, animated: true)
                        showAlert(title: "Login Successful", message: "Welcome, Admin")
                    }
                } else {
                    if let nextPage = storyboard?.instantiateViewController(withIdentifier: "tabBarView") as? TabBarController {
                        nextPage.emailCurrent = user.email!
                        nextPage.nameCurrent = user.name!
                        nextPage.balanceCurrent = Int(user.balance)
                        self.navigationController?.pushViewController(nextPage, animated: true)
                        showAlert(title: "Login Successful", message: "Welcome, \(user.name!)")
                    }
                }
            } else {
                showAlert(title: "Wrong Credentials", message: "Please enter correct email and password.")
            }
        } catch {
            showAlert(title: "Error", message: "Failed to fetch user data.")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}
