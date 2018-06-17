//
//  MainTabBarViewController.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 15.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRootViewController()
    }

    private func setupRootViewController() {

        // Flickr Controller
        let flickrNavigationController: UINavigationController = UIStoryboard(.images).instantiateViewController()
        flickrNavigationController.tabBarItem = UITabBarItem(title: "Flickr", image: #imageLiteral(resourceName: "flickr"), selectedImage: nil)

        let flickrImageViewController: ImagesViewController = UIStoryboard(.images).instantiateViewController()
        flickrImageViewController.viewModel = FlickrViewModel()
        flickrNavigationController.viewControllers = [flickrImageViewController]

        // Saves Controller
        let realmNavigationController: UINavigationController = UIStoryboard(.images).instantiateViewController()
        realmNavigationController.tabBarItem = UITabBarItem(title: "Saves", image: #imageLiteral(resourceName: "file-folder"), selectedImage: nil)

        let realmImageViewController: ImagesViewController = UIStoryboard(.images).instantiateViewController()
        realmImageViewController.viewModel = RealmViewModel()
        realmNavigationController.viewControllers = [realmImageViewController]

        // Set VCs in TabBarViewController
        setViewControllers([flickrNavigationController, realmNavigationController], animated: false)
    }

}
