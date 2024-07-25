//
//  UpdateBookViewController.swift
//  GRameJia Book
//
//  Created by prk on 7/24/24.
//

import UIKit

class UpdateBookViewController: UIViewController {

    var bookData: book!
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Edit Book Details"
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
