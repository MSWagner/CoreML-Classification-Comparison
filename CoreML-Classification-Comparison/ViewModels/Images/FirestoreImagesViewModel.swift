//
//  FirestoreImagesViewModel.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 16.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class FirestoreImagesViewModel {

    // MARK: - Properties

    private var currentFirestoreURLs = MutableProperty<[String]>([])
    private var currentPage = MutableProperty<Int?>(nil)
    lazy var pageCount: Property<Int?> = {

        var imageCountFunction: (Int) -> Int = { imageCount in
            return imageCount > 0 ? (imageCount / 30 >= 1 ? imageCount / 30 : 1) : 0
        }

        let initial = imageCountFunction(currentFirestoreURLs.value.count)
        let producer = currentFirestoreURLs.producer.map { imageCountFunction($0.count) }

        return Property(initial: initial, then: producer)
    }()

    private let _photos = MutableProperty<[Photo]>([])
    lazy var photos: Property<[Photo]> = {
        return Property(self._photos)
    }()

    private var _lastQuery = MutableProperty<String?>(nil)
    var lastQuery: String? {
        return _lastQuery.value
    }

    lazy var queryStatus: Property<QueryStatus> = {
        let initial = QueryStatus(lastQuery: lastQuery,
                                  currentPage: currentPage.value,
                                  pageCount: pageCount.value)

        let producer = SignalProducer
            .combineLatest(_lastQuery.producer,
                           currentPage.producer,
                           pageCount.producer)
            .map { QueryStatus(lastQuery: $0.0,
                               currentPage: $0.1,
                               pageCount: $0.2) }

        return Property(initial: initial, then: producer)
    }()

    var navigationTitle: String {
        return Strings.ImagesViewController.realmTitle
    }

    // MARK: - Init

    init() {
        _lastQuery.producer
            .startWithValues { [weak self] lastQuery in
                guard let `self` = self else { return }

                let fireStoreObjects = FirestoreController.shared.firestoreResultObjects

                if let query = lastQuery {
                    let queriedImageURLs = fireStoreObjects.value
                        .filter { $0.identifier.contains(query) }
                        .flatMap { $0.imageResults.map { $0.url } }

                    let queriedImageURLSet = Set<String>(queriedImageURLs)

                    self.currentFirestoreURLs.value = Array(queriedImageURLSet)
                } else {
                    self.currentFirestoreURLs.value = []
                }
            }

        SignalProducer.combineLatest(currentFirestoreURLs.producer,
                                     currentPage.producer)
            .startWithValues { [weak self] urls, currentPage in
                guard let `self` = self else { return }

                if let page = currentPage, let query = self.lastQuery, urls.count > 0 {
                    let startIndex = page > 1 ? (page * 30) - 1 : 0
                    var endIndex = startIndex + 30

                    endIndex = endIndex > urls.count - 1 ? urls.count - 1 : endIndex

                    var pageUrls = [String]()

                    if startIndex != endIndex {
                        for index in (startIndex...endIndex) {
                            pageUrls.append(urls[index])
                        }
                    } else {
                        pageUrls.append(urls[startIndex])
                    }

                    self._photos.value = pageUrls
                        .compactMap { Photo(urlString: $0, searchQuery: query) }

                } else {
                    self._photos.value = []
                }
            }
    }
}

// MARK: - ImageCollectionViewModel

extension FirestoreImagesViewModel: ImageCollectionViewModel {

    func searchFor(_ query: String, page: Int? = nil) {
        _lastQuery.value = query
        self.currentPage.value = page != nil ? page : 1
    }

    func onNextPage() {
        guard let currentPage = currentPage.value, let pageCount = pageCount.value, let query = lastQuery else { return }

        let nextPage = currentPage + 1 <= pageCount ? currentPage + 1 : 1

        searchFor(query, page: nextPage)

    }

    func onLastPage() {
        guard let currentPage = currentPage.value, let query = lastQuery else { return }

        let nextPage = currentPage - 1 > 0 ? currentPage - 1 : 1

        searchFor(query, page: nextPage)
    }
}

