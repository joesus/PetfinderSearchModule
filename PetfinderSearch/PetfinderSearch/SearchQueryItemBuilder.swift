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

    static func build(from parameters: SearchParameters) -> Set<URLQueryItem> {
        var items: Set = [
            URLQueryItem(
                name: SearchQueryItemKeys.location,
                value: parameters.zipCode.rawValue
            )
        ]

        if let species = parameters.species {
            items.insert(
                URLQueryItem(
                    name: SearchQueryItemKeys.species,
                    value: speciesValue(from: species)
                )
            )
        }

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
}
