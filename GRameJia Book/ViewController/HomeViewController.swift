//
//  HomeViewController.swift
//  GRameJia Book
//
//  Created by prk on 7/24/24.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        context = appDelegate.persistentContainer.viewContext
        
        bookTable.delegate = self
        bookTable.dataSource = self
        
        fetchBookData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchBookData()
    }
    
    @IBOutlet weak var bookTable: UITableView!
    
    var bookList = [book]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCellBooks") as! HomeTableViewCell
        
        let bookTitle = bookList[indexPath.row].title

        cell.bookTitle.text = bookTitle
        cell.bookAuthor.text = bookList[indexPath.row].author
        cell.bookPublisher.text = bookList[indexPath.row].publisher
        cell.bookPrice.text = "Rp \(bookList[indexPath.row].price)"
        cell.bookImage.image = UIImage(named: bookList[indexPath.row].image)
        
        let tabBar = tabBarController as! TabBarController
        
        cell.handleInsert = {
            let entity = NSEntityDescription.entity(forEntityName: "Cart", in: self.context)!
            
            let newCart = NSManagedObject(entity: entity, insertInto: self.context)
            newCart.setValue(tabBar.emailCurrent, forKey: "userEmail")
            newCart.setValue(bookTitle, forKey: "bookTitle")
            
            do {
                try self.context.save()
                
                self.showAlert(title: "Added to Cart", message: "Book is added to your cart successfully")
            } catch {
                self.showAlert(title: "Error", message: "Failed to save cart data.")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func fetchBookData() {
        bookList.removeAll()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        
        do {
            let results = try context.fetch(request) as! [NSManagedObject]
            
            for data in results {
                bookList.append(book(
                    title: (data.value(forKey: "title") as! String),
                    author: (data.value(forKey: "author") as! String),
                    publisher: (data.value(forKey: "publisher") as! String),
                    price: (data.value(forKey: "price") as! Int),
                    image: (data.value(forKey: "image") as! String)
                ))
            }
            
            bookTable.reloadData()
        } catch {
            print("Error fetching book data")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}
