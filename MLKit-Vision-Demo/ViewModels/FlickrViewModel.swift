//
//  FlickrViewModel.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 10.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import ReactiveSwift
import MapKit
import Result
import CoreData

class FlickrViewModel {

    private var _currentFlickrPhotos = MutableProperty<FlickrPhotos?>(nil)
    lazy var currentFlickrPhotos: Property<FlickrPhotos?> = {
        return Property(self._currentFlickrPhotos)
    }()

    private let _photos = MutableProperty<[Photo]>([])
    lazy var photos: Property<[Photo]> = {
        return Property(self._photos)
    }()

    private var currentNetworkRequest: Disposable?

    init() {
        _currentFlickrPhotos.producer.startWithValues { [weak self] (flickrPhotos) in
            guard let `self` = self, let flickrPhotos = flickrPhotos else { return }

            self._photos.value = flickrPhotos.photo
                .compactMap { Photo(urlString: "https://farm\($0.farm).staticflickr.com/\($0.server)/\($0.id)_\($0.secret)_q.jpg") }
        }
    }

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

    func searchFor(_ query: String, page: Int? = nil) {
        currentNetworkRequest?.dispose()
        currentNetworkRequest = search.apply((query, page)).start()
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
