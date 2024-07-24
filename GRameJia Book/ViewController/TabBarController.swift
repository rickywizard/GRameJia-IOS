//
//  HomeTabBarController.swift
//  GRameJia Book
//
//  Created by prk on 7/24/24.
//

import UIKit

class TabBarController: UITabBarController {
    
    var emailCurrent: String = ""
    var nameCurrent: String = ""

    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        print(emailCurrent)
//        print(nameCurrent)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
