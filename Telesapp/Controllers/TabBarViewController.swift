//
//  TabBarViewController.swift
//  Telesapp
//
//  Created by Trung on 15/05/2023.
//

import UIKit

class TabBarViewController: UITabBarController {



    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.items![0].image = UIImage(named: "chat")
        self.tabBar.items![0].selectedImage = UIImage(named: "chat1")
        self.tabBar.items![1].image = UIImage(named: "profile")
        self.tabBar.items![1].selectedImage = UIImage(named: "profile1")
    }
    

   

}
