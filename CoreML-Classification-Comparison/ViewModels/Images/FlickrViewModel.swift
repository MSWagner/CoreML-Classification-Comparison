//
//  FlickrViewModel.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 10.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import PKHUD
import Reachability

class FlickrViewModel {

    // MARK: - Properties

    private var currentNetworkRequest: Disposable?

    private var _currentFlickrPhotos = MutableProperty<FlickrPhotos?>(nil)
    lazy var currentFlickrPhotos: Property<FlickrPhotos?> = {
        return Property(self._currentFlickrPhotos)
    }()

    private let _photos = MutableProperty<[Photo]>([])

    var reachability = Reachability()

    // MARK: - ImageCollectionViewModel Stored Properties

    lazy var photos: Property<[Photo]> = {
        return Property(self._photos)
    }()

    lazy var queryStatus: Property<QueryStatus> = {
        let initial = QueryStatus(lastQuery: currentFlickrPhotos.value?.query,
                                  currentPage: currentFlickrPhotos.value?.page,
                                  pageCount: currentFlickrPhotos.value?.pages)

        let producer = currentFlickrPhotos.producer.map { QueryStatus(lastQuery: $0?.query,
                                                                      currentPage: $0?.page,
                                                                      pageCount: $0?.pages) }

        return Property(initial: initial, then: producer)
    }()

    var lastQuery: String? {
        return queryStatus.value.lastQuery
    }

    var navigationTitle: String {
        return Strings.ImagesViewController.flickrTitle
    }

    // MARK: - Init

    init() {
        _currentFlickrPhotos.producer.startWithValues { [weak self] (flickrPhotos) in
            guard let `self` = self, let flickrPhotos = flickrPhotos, let searchQuery = flickrPhotos.query else { return }

            self._photos.value = flickrPhotos.photo
                .compactMap { Photo(urlString: "https://farm\($0.farm).staticflickr.com/\($0.server)/\($0.id)_\($0.secret)_q.jpg", searchQuery: searchQuery) }
        }
    }

    // MARK: - Search

    lazy var search: Action<(String, Int?), FlickrPhotoSearchResult, APIError> = {

        return Action { [weak self] queryAndPage in

            let query = queryAndPage.0
            var page = queryAndPage.1 ?? 1

            return APIClient
                .request(.photosSearch(text: query, page: page), type: FlickrPhotoSearchResult.self)
                .on { [weak self] (value) in
                    guard let `self` = self else { return }

                    var photos = value.photos
                    photos.query = query
                    self._currentFlickrPhotos.value = photos
            }
        }
    }()
}

// MARK: - ImageCollectionViewModel

extension FlickrViewModel: ImageCollectionViewModel {

    func searchFor(_ query: String, page: Int? = nil) {
        currentNetworkRequest?.dispose()

        if reachability?.connection != .wifi || reachability?.connection != .cellular {
            HUD.flash(.label(Strings.Network.errorNoConnection), delay: 1)
            return
        }

        reachability?.whenUnreachable = { _ in
            HUD.flash(.label(Strings.Network.errorNoConnection), delay: 1)
        }

        currentNetworkRequest = search.apply((query, page))
            .startWithResult{ [weak self] (result) in
                switch result {
                case .failure(.producerFailed(let error)):
                    HUD.flash(.label(error.errorDescription), delay: 1)
                default: break
                }

                self?.reachability?.stopNotifier()
            }
    }

    func onNextPage() {
        guard let currentPhotos = self._currentFlickrPhotos.value, let query = currentPhotos.query else { return }
        let pageCount = currentPhotos.pages
        let page = currentPhotos.page + 1 <= pageCount ? currentPhotos.page + 1 : 1

        searchFor(query, page: page)
    }

    func onLastPage() {
        guard let currentPhotos = self._currentFlickrPhotos.value, let query = currentPhotos.query else { return }
        let page = currentPhotos.page - 1 > 0 ? currentPhotos.page - 1 : 1

        searchFor(query, page: page)
    }
}
