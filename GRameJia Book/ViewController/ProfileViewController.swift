//
//  ProfileViewController.swift
//  GRameJia Book
//
//  Created by prk on 7/25/24.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var context: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        context = appDelegate.persistentContainer.viewContext
        
        historyTable.delegate = self
        historyTable.dataSource = self
        
        fetchUserData()
        fetchHistoryByEmail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUserData()
        fetchHistoryByEmail()
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet weak var historyTable: UITableView!
    
    var historyList = [book]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellHistory") as! HistoryTableViewCell

        cell.bookTitle.text = historyList[indexPath.row].title
        cell.bookAuthor.text = historyList[indexPath.row].author
        cell.bookPublisher.text = historyList[indexPath.row].publisher
        cell.bookPrice.text = "Rp \(historyList[indexPath.row].price)"
        cell.bookImage.image = UIImage(named: historyList[indexPath.row].image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func fetchUserData() {
        let tabBar = tabBarController as! TabBarController
    
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", tabBar.emailCurrent)
            
        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                nameLabel.text = user.name
                emailLabel.text = user.email
                balanceLabel.text = "Rp \(user.balance)"

            }
        } catch {
            print("Error fetching user data: \(error.localizedDescription)")
        }
    }
    
    func fetchHistoryByEmail() {
        historyList.removeAll()
        
        let tabBar = tabBarController as! TabBarController
        
        let userEmail = tabBar.emailCurrent
        
        let fetchRequest: NSFetchRequest<History> = History.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userEmail == %@", userEmail)
        
        do {
            let fetchedHistory = try context.fetch(fetchRequest)
            for history in fetchedHistory {
                if let bookTitle = history.bookTitle {
                    fetchBookDetails(for: bookTitle)
                }
            }
        } catch {
            print("Failed to fetch history data.")
        }
    }
    
    func fetchBookDetails(for bookTitle: String) {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", bookTitle)
        
        do {
            let fetchedBooks = try context.fetch(fetchRequest)
            if let bookData = fetchedBooks.first {
                historyList.append(book(
                    title: bookTitle,
                    author: bookData.author!,
                    publisher: bookData.publisher!,
                    price: Int(bookData.price),
                    image: bookData.image!
                ))
                
                historyTable.reloadData()
            }
        } catch {
            print("Failed to fetch book details.")
        }
    }
    
}
