//
//  AddBookViewController.swift
//  GRameJia Book
//
//  Created by prk on 7/24/24.
//

import UIKit
import CoreData

class AddBookViewController: UIViewController {

    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Add New Book"
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        context = appDelegate.persistentContainer.viewContext
    }

    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var authorField: UITextField!
    
    @IBOutlet weak var publisherField: UITextField!
    
    @IBOutlet weak var priceField: UITextField!
    
    @IBOutlet weak var imageField: UITextField!
    
    @IBAction func onAddBtnClick(_ sender: Any) {
        
        guard let title = titleField.text, !title.isEmpty else {
            showAlert(title: "Book title is empty", message: "Book title must not be empty")
            return
        }
        
        guard let author = authorField.text, !author.isEmpty else {
            showAlert(title: "Author is empty", message: "Author must not be empty")
            return
        }
        
        guard let publisher = publisherField.text, !publisher.isEmpty else {
            showAlert(title: "Publisher is empty", message: "Publisher must not be empty")
            return
        }
        
        guard let price = priceField.text, !price.isEmpty else {
            showAlert(title: "Price is empty", message: "Price must not be empty")
            return
        }
        
        guard let image = imageField.text, !image.isEmpty else {
            showAlert(title: "Image is empty", message: "Image must not be empty")
            return
        }
        
        saveBook(title: title, author: author, publisher: publisher, price: Int64(price)!, image: image)
    }
    
    func saveBook(title: String, author: String, publisher: String, price: Int64, image: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Book", in: context)!
        
        let newBook = NSManagedObject(entity: entity, insertInto: context)
        newBook.setValue(title, forKey: "title")
        newBook.setValue(author, forKey: "author")
        newBook.setValue(publisher, forKey: "publisher")
        newBook.setValue(price, forKey: "price")
        newBook.setValue(image, forKey: "image")
        
        do {
            try context.save()
            
            if let nextPage = storyboard?.instantiateViewController(withIdentifier: "adminView") as? AdminViewController {
                self.navigationController?.pushViewController(nextPage, animated: true)
                showAlert(title: "Book Added", message: "Your new book is added successfully")
            }
        } catch {
            showAlert(title: "Error", message: "Failed to save book data.")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
