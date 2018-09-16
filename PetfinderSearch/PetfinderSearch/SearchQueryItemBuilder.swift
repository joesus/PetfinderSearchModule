//
//  SearchQueryItemBuilder.swift
//  PetfinderSearch
//
//  Created by Joe Susnick on 9/16/18.
//  Copyright © 2018 Joe Susnick. All rights reserved.
//

import AnimalData
import AnimalSearchModule

enum SearchQueryItemBuilder {

    private enum Keys {
        static let apiKey = "key"
        static let outputFormat = "format"
        static let recordLength = "output"

        static let location = "location"
        static let species = "animal"

        static let offset = "offset"
        static let count = "count"
    }

    private enum Values {
        static let apiKey = "APIKEY"
        static let outputFormat = "json"
        static let recordLength = "short"
    }

    static func build(
        searchParameters: SearchParameters,
        paginationCursor: PaginationCursor
        ) -> Set<URLQueryItem> {

        var items: Set = [
            URLQueryItem(
                name: Keys.apiKey,
                value: Values.apiKey
            ),
            URLQueryItem(
                name: Keys.outputFormat,
                value: Values.outputFormat
            ),
            URLQueryItem(
                name: Keys.recordLength,
                value: Values.recordLength
            )
        ]

        items = items.union(buildPagingQueryItems(for: paginationCursor))
            .union(buildSearchParameterQueryItems(for: searchParameters))

        return items
    }

    private static let speciesValueMapping = [
        Species.cat: "cat",
        .dog: "dog"
    ]

    private static func speciesValue(from species: Species) -> String {
        guard let value = speciesValueMapping[species] else {
            fatalError("Unknown species")
        }

        return value
    }

    private static func buildSearchParameterQueryItems(
        for searchParameters: SearchParameters
        ) -> Set<URLQueryItem> {

        var items: Set = [
            URLQueryItem(
                name: Keys.location,
                value: searchParameters.zipCode.rawValue
            )
        ]

        if let species = searchParameters.species {
            items.insert(
                URLQueryItem(
                    name: Keys.species,
                    value: speciesValue(from: species)
                )
            )
        }

        return items
    }

    private static func buildPagingQueryItems(
        for paginationCursor: PaginationCursor
        ) -> Set<URLQueryItem> {

        return [
            URLQueryItem(
                name: Keys.offset,
                value: String(paginationCursor.offset)
            ),
            URLQueryItem(
                name: Keys.count,
                value: String(paginationCursor.size)
            )
        ]
    }

}
