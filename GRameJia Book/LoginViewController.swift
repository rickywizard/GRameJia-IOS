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
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        context = appDelegate.persistentContainer.viewContext
        
        initDummy()
    }
    
    func initDummy(){
        let entityTarget = NSEntityDescription.entity(forEntityName: "User", in: context)
        if (entityTarget != nil) {
            let newUser = NSManagedObject(entity: entityTarget!, insertInto: context)
            newUser.setValue("dummy@gmail.com", forKey: "email")
            newUser.setValue("Dummy", forKey: "name")
            newUser.setValue("dummy123", forKey: "password")
        }

        do{
            try context.save()
        }catch{
            showAlert(title: "Error", message: "Failed to save data.")
        }
    }
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func onLoginBtnClick(_ sender: Any) {
        
        guard let email = emailField.text, !email.isEmpty else {
            showAlert(title:"Email is empty",message: "Email must not be empty.")
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            showAlert(title:"Password is empty",message: "Password must not be empty.")
            return
        }
        
        // auth
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "email == %@", email)
                
                do {
                    let users = try context.fetch(fetchRequest)
                    
                    if let user = users.first {
                        if user.password == password {
                            showAlert(title: "Login Successful", message: "Welcome!")
                            // after login success, perform segue
                            
                        } else {
                            showAlert(title: "Incorrect Password", message: "Please enter correct password.")
                        }
                    } else {
                        showAlert(title: "User Not Found", message: "No user found with this email.")
                    }
                } catch {
                    showAlert(title: "Error", message: "Failed to fetch data.")
                }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}
