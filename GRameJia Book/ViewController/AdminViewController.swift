//
//  AdminViewController.swift
//  GRameJia Book
//
//  Created by prk on 7/24/24.
//

import UIKit
import CoreData

class AdminViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        context = appDelegate.persistentContainer.viewContext
        
        bookTable.delegate = self
        bookTable.dataSource = self
        
        fetchBookData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        fetchBookData()
    }
    
    var bookList = [book]()
    
    @IBOutlet weak var bookTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellBooks") as! AdminTableViewCell
        
        cell.bookTitle.text = bookList[indexPath.row].title
        cell.bookAuthor.text = bookList[indexPath.row].author
        cell.bookPublisher.text = bookList[indexPath.row].publisher
        cell.bookPrice.text = "Rp \(bookList[indexPath.row].price)"
        cell.bookImage.image = UIImage(named: bookList[indexPath.row].image)
        
        // navigate to update page
        cell.toUpdate = {
            if let nextPage = self.storyboard?.instantiateViewController(withIdentifier: "updateView") as? UpdateBookViewController {
                nextPage.bookData = self.bookList[indexPath.row]
                self.navigationController?.pushViewController(nextPage, animated: true)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
            
            request.predicate = NSPredicate(format: "title == %@", bookList[indexPath.row].title)
            
            do {
                let results = try context.fetch(request) as! [NSManagedObject]

                for data in results {
                    context.delete(data)
                }

                try context.save()
                
                fetchBookData()
            } catch {
                print("Error deleting book")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
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
            print("Error fetching game data")
        }
    }

}
