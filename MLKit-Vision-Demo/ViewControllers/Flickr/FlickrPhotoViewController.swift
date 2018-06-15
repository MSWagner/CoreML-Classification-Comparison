//
//  FlickrPhotoViewController.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 10.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class FlickrPhotoViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var nextPageButtonBelow: UIButton!
    @IBOutlet weak var lastPageButtonBelow: UIButton!
    @IBOutlet weak var pageControlView: UIView!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var pageControlHeightConstraint: NSLayoutConstraint!

    // MARK: - NavigationBar Buttons

    var nextPageButton: UIBarButtonItem!
    var lastPageButton: UIBarButtonItem!

    // MARK: - Properties

    private var disposableBag = CompositeDisposable()

    private let searchController = UISearchController(searchResultsController: nil)
    private let isSearchBarActive = MutableProperty<Bool>(false)

    private let cellIdentifier = "ImageCollectionCell"

    var viewModel: FlickrViewModel!

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = FlickrViewModel()

        setupSearch()
        setupCollectionView()
        bindViewModel()
        setupNavigationBarButtons()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disposableBag.dispose()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindKeyboard()
    }

    // MARK: - Search Setup

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)

        flowLayout.itemSize = CGSize(width: collectionView.bounds.width / 3 - 1, height: collectionView.bounds.width / 3 - 1)
        flowLayout.minimumLineSpacing = 1
    }

    private func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Images"
        searchController.searchBar.returnKeyType = .done
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        definesPresentationContext = true

        // Cancel text
        searchController.searchBar.tintColor = UIColor.white

        // Background
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.white
                backgroundview.layer.cornerRadius = 10
                backgroundview.clipsToBounds = true
            }
        }
    }

    private func setupNavigationBarButtons() {
        nextPageButton = UIBarButtonItem(title: "Next Page", style: .plain, target: self, action: #selector(onNextPage(_:)))
        lastPageButton = UIBarButtonItem(title: "Last Page", style: .plain, target: self, action: #selector(onLastPage(_:)))

        pageControlView.backgroundColor = Colors.Main.red
        nextPageButtonBelow.backgroundColor = .clear
        lastPageButtonBelow.backgroundColor = .clear
        pageCountLabel.textColor = .white
        lastPageButtonBelow.tintColor = .white
        nextPageButtonBelow.tintColor = .white

        SignalProducer
            .combineLatest(viewModel.currentFlickrPhotos.producer,
                           isSearchBarActive.producer)
            .startWithValues { [weak self] lastFlickrPhotos, isSearchBarActive in
                guard let `self` = self else { return }

                var hasNextPage = false
                var hasLastPage = false

                if let lastFlickr = lastFlickrPhotos, lastFlickr.query != nil {
                    hasNextPage = lastFlickr.page + 1 <= lastFlickr.pages ? true : false
                    hasLastPage = lastFlickr.page - 1 > 0 ? true : false
                }

                self.navigationItem.rightBarButtonItem = hasNextPage ? self.nextPageButton : nil
                self.navigationItem.leftBarButtonItem = hasLastPage ? self.lastPageButton : nil

                if isSearchBarActive {
                    self.pageControlView.isHidden = false
                    self.pageControlHeightConstraint.constant = 45
                }

                self.nextPageButtonBelow.isHidden = hasNextPage ? false : true
                self.lastPageButtonBelow.isHidden = hasLastPage ? false : true

                self.navigationItem.title = lastFlickrPhotos?.page != nil
                    ? "Page: \(lastFlickrPhotos!.page)/\(lastFlickrPhotos!.pages)"
                    : "Flickr Image Search"

                self.pageCountLabel.text = lastFlickrPhotos?.page != nil
                    ? "Page: \(lastFlickrPhotos!.page)/\(lastFlickrPhotos!.pages)"
                    : "Enter a search tag"
            }

    }

    // MARK: - Keyboard

    private func bindKeyboard() {
        disposableBag = CompositeDisposable()
        disposableBag += KeyboardObserver.shared.keyboardWillShowSignal.producer
            .skipNil()
            .startWithValues { keyboardNotification in
                self.collectionView.contentInset.bottom = keyboardNotification.keyboardEndFrame.height
            }

        disposableBag += KeyboardObserver.shared.keyboardWillHideSignal.producer
            .skipNil()
            .startWithValues { [weak self] keyboardNotification in
                self?.collectionView.contentInset.bottom = 0
        }
    }

    // MARK: - Datasource

    private func bindViewModel() {
        viewModel.photos.producer.startWithValues { [weak self] photos in
            guard let `self` = self else { return }

            self.collectionView.reloadData()
        }
    }

    // MARK: - IBActions

    @IBAction func onNextPage(_ sender: Any) {
        viewModel.onNextPage()
    }

    @IBAction func onLastPage(_ sender: Any) {
        viewModel.onLastPage()
    }
}

// MARK: - UICollectionViewDataSource

extension FlickrPhotoViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let photos = viewModel?.photos.value {
            return photos.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ImageCollectionCell

        if let viewModel = viewModel {
            cell.configure(photo: viewModel.photos.value[indexPath.row])
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension FlickrPhotoViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionCell

        let photo = cell.photo
        let imageProcessingViewModel = ImageProcessingViewModel(photo: photo!)
        let imageProcessingViewController: ImageProcessingViewController = UIStoryboard(.processing).instantiateViewController()

        imageProcessingViewController.viewModel = imageProcessingViewModel

        navigationItem.searchController?.searchBar.resignFirstResponder()
        navigationController?.pushViewController(imageProcessingViewController, animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension FlickrPhotoViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let strippedString = searchController.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespaces) else { return }

        if strippedString.count < 3 || strippedString == viewModel.currentFlickrPhotos.value?.query { return }

        viewModel.searchFor(strippedString)
    }
}

// MARK: - UISearchBarDelegate

extension FlickrPhotoViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        isSearchBarActive.value = true
        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        isSearchBarActive.value = false
        return true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.text = viewModel.currentFlickrPhotos.value?.query
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        pageControlView.isHidden = true
        pageControlHeightConstraint.constant = 0
    }
}
