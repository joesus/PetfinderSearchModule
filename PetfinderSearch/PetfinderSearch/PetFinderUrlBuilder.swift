//
//  PetFinderUrlBuilder.swift
//  PetfinderSearch
//
//  Created by Joe Susnick on 10/28/17.
//  Copyright © 2017 Joesus. All rights reserved.
//

import AnimalSearchModule

enum UrlBuilder {

    enum CommonValues {
        static let hostname = "api.petfinder.com"
        static let apiKey = "APIKEY"
        static let outputFormat = "json"
    }

    enum PaginationKeys {
        static let offset = "offset"
        static let count = "count"
    }

    enum MethodPaths {
        static let search = "/pet.find"
    }

    enum BaseQueryItemKeys {
        static let apiKey = "key"
        static let outputFormat = "format"
        static let recordLength = "output"
    }

    static func buildSearchUrl(
        searchParameters: SearchParameters,
        range cursor: PaginationCursor
        ) -> URL {

        var components = baseApiUrlComponents
        components.path = MethodPaths.search

        var queryItems = components.queryItems ?? []

        queryItems.append(contentsOf:
            SearchQueryItemBuilder.build(from: searchParameters)
                .union(buildPagingQueryItems(for: cursor))
                .union([RecordLength.short.queryItem])
                .map { $0 }
        )

        components.queryItems = queryItems

        guard let url = components.url else {
            fatalError("Components should be able to create a valid URL")
        }

        return url
    }

    static let baseApiUrlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = CommonValues.hostname
        components.queryItems = Array(baseQueryItems)
        return components
    }()

    static let baseQueryItems: Set = [
        URLQueryItem(
            name: BaseQueryItemKeys.apiKey,
            value: CommonValues.apiKey
        ),
        URLQueryItem(
            name: BaseQueryItemKeys.outputFormat,
            value: CommonValues.outputFormat
        )
    ]

    static func buildPagingQueryItems(
        for paginationCursor: PaginationCursor
        ) -> Set<URLQueryItem> {

        return [
            URLQueryItem(
                name: UrlBuilder.PaginationKeys.offset,
                value: String(paginationCursor.offset)
            ),
            URLQueryItem(
                name: UrlBuilder.PaginationKeys.count,
                value: String(paginationCursor.size)
            )
        ]
    }

}
