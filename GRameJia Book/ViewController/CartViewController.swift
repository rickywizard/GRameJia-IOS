//
//  CartViewController.swift
//  GRameJia Book
//
//  Created by prk on 7/25/24.
//

import UIKit
import CoreData

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var context: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        context = appDelegate.persistentContainer.viewContext
        
        cartTable.delegate = self
        cartTable.dataSource = self
        
        fetchCartByEmail()
        updatePrice()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCartByEmail()
        updatePrice()
    }
    
    var cartList = [book]()
    
    var totalPrice = 0
    
    @IBOutlet weak var cartTable: UITableView!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBAction func onCheckoutBtnClick(_ sender: Any) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCart") as! CartTableViewCell

        cell.bookTitle.text = cartList[indexPath.row].title
        cell.bookAuthor.text = cartList[indexPath.row].author
        cell.bookPublisher.text = cartList[indexPath.row].publisher
        cell.bookPrice.text = "Rp \(cartList[indexPath.row].price)"
        cell.bookImage.image = UIImage(named: cartList[indexPath.row].image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
            
            let tabBar = tabBarController as! TabBarController
            
            request.predicate = NSPredicate(format: "userEmail == %@ AND bookTitle == %@", tabBar.emailCurrent, cartList[indexPath.row].title)
            
            do {
                let results = try context.fetch(request) as! [NSManagedObject]

                for data in results {
                    context.delete(data)
                }

                try context.save()
                
                cartList.remove(at: indexPath.row)
                updatePrice()
                cartTable.reloadData()
            } catch {
                print("Error deleting book")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func fetchCartByEmail() {
        cartList.removeAll()
        
        let tabBar = tabBarController as! TabBarController
        
        let userEmail = tabBar.emailCurrent
        
        let fetchRequest: NSFetchRequest<Cart> = Cart.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userEmail == %@", userEmail)
        
        do {
            let fetchedCarts = try context.fetch(fetchRequest)
            for cart in fetchedCarts {
                if let bookTitle = cart.bookTitle {
                    fetchBookDetails(for: bookTitle)
                }
            }
        } catch {
            showAlert(title: "Error", message: "Failed to fetch cart data.")
        }
    }
    
    func fetchBookDetails(for bookTitle: String) {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", bookTitle)
        
        do {
            let fetchedBooks = try context.fetch(fetchRequest)
            if let bookData = fetchedBooks.first {
                // Assuming you have some way to store or display these details
                cartList.append(book(
                    title: bookTitle,
                    author: bookData.author!,
                    publisher: bookData.publisher!,
                    price: Int(bookData.price),
                    image: bookData.image!
                ))
                
                cartTable.reloadData()
            }
        } catch {
            showAlert(title: "Error", message: "Failed to fetch book details.")
        }
    }
    
    func updatePrice() {
        totalPrice = 0
        for cart in cartList {
            totalPrice += cart.price
        }
        
        totalPriceLabel.text = "Rp \(totalPrice)"
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
