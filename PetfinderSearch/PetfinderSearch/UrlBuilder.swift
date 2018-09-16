//
//  UrlBuilder.swift
//  PetfinderSearch
//
//  Created by Joe Susnick on 10/28/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import AnimalSearchModule

enum UrlBuilder {

    static let hostname = "api.petfinder.com"
    static let search = "/pet.find"

    static func buildSearchUrl(
        searchParameters: SearchParameters,
        range cursor: PaginationCursor
        ) -> URL {

        var components = baseApiUrlComponents
        components.path = search
        components.queryItems = Array(
            SearchQueryItemBuilder.build(
                searchParameters: searchParameters,
                paginationCursor: cursor
            )
        )

        guard let url = components.url else {
            fatalError("Components should be able to create a valid URL")
        }

        return url
    }

    static let baseApiUrlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = hostname
        return components
    }()
}
