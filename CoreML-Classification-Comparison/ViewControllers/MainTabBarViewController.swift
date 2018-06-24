//
//  MainTabBarViewController.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 15.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import UIKit
import PKHUD
import DKImagePickerController

class MainTabBarViewController: UITabBarController, PermissionProtocol {

    // MARK: - Properties

    private var cameraButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))

    private let cameraPicker = UIImagePickerController()
    private let libraryPicker = DKImagePickerController()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRootViewController()
    }

    override func viewSafeAreaInsetsDidChange() {
        cameraButton.frame.origin.y -= view.safeAreaInsets.bottom
    }

    // MARK: - Setup

    private func setupRootViewController() {

        // Flickr Controller
        let flickrNavigationController: UINavigationController = UIStoryboard(.images).instantiateViewController()
        flickrNavigationController.tabBarItem = UITabBarItem(title: Strings.TabBarViewControllter.flickrTitle, image: #imageLiteral(resourceName: "flickr"), selectedImage: nil)

        let flickrImageViewController: ImagesViewController = UIStoryboard(.images).instantiateViewController()
        flickrImageViewController.viewModel = FlickrViewModel()
        flickrNavigationController.viewControllers = [flickrImageViewController]

        // Photo Controller
        let viewController = UIViewController()
        let cameraNavigationController = UINavigationController(rootViewController: viewController)
        cameraNavigationController.title = ""

        // Saves Controller
        let realmNavigationController: UINavigationController = UIStoryboard(.images).instantiateViewController()
        realmNavigationController.tabBarItem = UITabBarItem(title: Strings.TabBarViewControllter.savesTitle, image: #imageLiteral(resourceName: "file-folder"), selectedImage: nil)

        let realmImageViewController: ImagesViewController = UIStoryboard(.images).instantiateViewController()
        realmImageViewController.viewModel = FirestoreImagesViewModel()
        realmNavigationController.viewControllers = [realmImageViewController]

        // Set VCs in TabBarViewController
        setViewControllers([flickrNavigationController, cameraNavigationController, realmNavigationController], animated: false)

        setupCameraButton()
    }

    private func setupCameraButton() {
        var cameraFrame = cameraButton.frame
        cameraFrame.origin.y = view.bounds.height - cameraFrame.height
        cameraFrame.origin.x = view.bounds.width/2 - cameraFrame.size.width/2
        cameraButton.frame = cameraFrame

        cameraButton.backgroundColor = Colors.Main.red
        cameraButton.layer.cornerRadius = cameraFrame.height/2
        view.addSubview(cameraButton)

        cameraButton.setImage(#imageLiteral(resourceName: "photo-camera"), for: .normal)
        cameraButton.addTarget(self, action: #selector(onCamera(sender:)), for: .touchUpInside)

        view.layoutIfNeeded()
    }

    // MARK: - Camera/Library

    @objc private func onCamera(sender: UIButton) {
        presentAlertPicker()
    }

    private func presentAlertPicker() {
        let title = "Add a image"
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.view.layoutIfNeeded()

        alert.addAction(UIAlertAction(title: Strings.Alert.camera,
                                      style: .default,
                                      handler: { _ in

            self.takePhotoFrom(.camera)
        }))

        alert.addAction(UIAlertAction(title: Strings.Alert.library,
                                      style: .default,
                                      handler: { _ in

            self.takePhotoFrom(.photoLibrary)
        }))

        alert.addAction(UIAlertAction(title: Strings.Alert.cancel,
                                      style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    private func takePhotoFrom(_ sourceType: UIImagePickerControllerSourceType) {
        havePermissionFor(sourceType)
            .startWithResult { [weak self] result in
                guard let `self` = self else { return }

                guard let isAccessGranted = result.value else { return }

                DispatchQueue.main.async {

                    if isAccessGranted {
                        let pickerController = DKImagePickerController()
                        pickerController.sourceType = sourceType.dkSourceType
                        pickerController.singleSelect = true

                        pickerController.didSelectAssets = { (assets: [DKAsset]) in

                            for asset in assets {
                                asset.fetchImageData(completeBlock: { imageData, _ in

                                    if let imageData = imageData {
                                        let photo = Photo(imageData: imageData)
                                        let viewModel = ImageProcessingViewModel(photo: photo)

                                        let processingViewController: ImageProcessingViewController = UIStoryboard(.processing).instantiateViewController()
                                        processingViewController.viewModel = viewModel
                                        processingViewController.title = Strings.ProcessingViewController.titlePickedImage

                                        let currentNavVC = self.viewControllers![self.selectedIndex] as! UINavigationController
                                        currentNavVC.pushViewController(processingViewController, animated: true)

                                        return
                                    }
                                })
                            }
                        }

                        self.present(pickerController, animated: true, completion: nil)

                    } else {
                        HUD.flash(.labeledError(title: Strings.Alert.accessPermittedTitle, subtitle: Strings.Alert.accessPermittedSubTitle), delay: 2)
                    }
                }
            }
    }
}
