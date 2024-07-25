//
//  UpdateBookViewController.swift
//  GRameJia Book
//
//  Created by prk on 7/24/24.
//

import UIKit
import CoreData

class UpdateBookViewController: UIViewController {

    var bookData: book!
    
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Edit Book Details"
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        titleField.text = bookData.title
        authorField.text = bookData.author
        publisherField.text = bookData.publisher
        priceField.text = String(bookData.price)
        imageField.text = bookData.image
    }
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var authorField: UITextField!
    
    @IBOutlet weak var publisherField: UITextField!
    
    @IBOutlet weak var priceField: UITextField!
    
    @IBOutlet weak var imageField: UITextField!
    
    @IBAction func onUpdateBtnClick(_ sender: Any) {
        
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
        
        saveUpdatedBook(title: title, author: author, publisher: publisher, price: Int64(price)!, image: image)
        
    }
    
    func saveUpdatedBook(title: String, author: String, publisher: String, price: Int64, image: String) {
        
        let oldBookTitle = bookData.title
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        
        
        request.predicate = NSPredicate(format: "title == %@", oldBookTitle)

        do {
            let results = try context.fetch(request) as! [NSManagedObject]

            for data in results {
                data.setValue(titleField.text, forKey: "title")
                data.setValue(authorField.text, forKey: "author")
                data.setValue(publisherField.text, forKey: "publisher")
                data.setValue(Int(priceField.text ?? "0"), forKey: "price")
                data.setValue(imageField.text, forKey: "image")
            }

            try context.save()
            
            if let nextPage = storyboard?.instantiateViewController(withIdentifier: "adminView") as? AdminViewController {
                self.navigationController?.pushViewController(nextPage, animated: true)
                showAlert(title: "Book Updated", message: "Successfully updated book data")
            }
        } catch {
            print("Updating error")
        }
        
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
